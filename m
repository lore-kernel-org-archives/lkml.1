Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbXLDVtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbXLDVtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXLDVtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:49:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:49055 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXLDVtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:49:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EdqMqqQrDDVdP6TjDpLqjKxfl2NODtfPE19yjZb5dulQl9QMRopiO+UWa0ZziKf/EPLJ06/WfHlLOsejcI92pVuDQM7UPIQiBvfzSj2TGfwcYs2mmH/kmd/2zogggzvi4homkQDcsSDdpCu9yVz2FMtFcRYzNIHf0bGVIdnX1r4=
Message-ID: <6934efce0712041338g75bec69co1cba9ce0cc9255b9@mail.gmail.com>
Date: Tue, 4 Dec 2007 13:38:59 -0800
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: solid state drive access and context switching
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <4755BC97.7050607@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47548BF4.3010907@nortel.com>
	 <20071203230629.725f4c7a@the-village.bc.nu>
	 <6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
	 <4755BC97.7050607@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > refinements could theoretically get us down one more (~100
> > microsecond).
>
> They've already done already better than that.  Here's a solid state
> drive with a claimed 20 microsecond access time:
>
> http://www.curtisssd.com/products/drives/hyperxclr

Right.  That looks to be RAM based, which means $$$$ compared to NAND,
so that's not going to breakout of a server niche.  I imagine the
latency is the device latency not the system latency.  By the time you
send the request through the fibrechannel stack and get the block back
it's gonna be much closer to 100 microseconds.  It's that OS visible
latency that you've got to design to.
