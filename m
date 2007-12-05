Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbXLEADy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbXLEADy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbXLEADr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:03:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:38977 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbXLEADq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oD9q6FBwcVu/sTbN1N0aTY5h7qpLeVSpFBy1hpkz1hC2cNKkPHYPZANn3jHldR2rgIs5JflHuio06rBpqoUhj8lpHVzgAi22KjGlOBTvxa3zvaQcorcyvbRg8WZhEMDX4Lvt6VSMwkkRbIat1nGne5OqYuXEEEXoBUWKjCBxS2k=
Message-ID: <6934efce0712041603y65e704c9v6377761ef292b6a5@mail.gmail.com>
Date: Tue, 4 Dec 2007 16:03:45 -0800
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: solid state drive access and context switching
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071204224525.GC26112@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47548BF4.3010907@nortel.com>
	 <20071203230629.725f4c7a@the-village.bc.nu>
	 <6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
	 <20071204203536.2bf6d025@the-village.bc.nu>
	 <6934efce0712041354n47c11d6ckbc7f4aa1e7c85f@mail.gmail.com>
	 <20071204224525.GC26112@lazybastard.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Maybe I'm missing something but I don't see it.  We want a block
> > interface for these devices, we just need a faster slimmer interface.
> > Maybe a new mtdblock interface that doesn't do erase would be the
> > place for?
>
> Doesn't do erase?  MTD has to learn almost all tricks from the block
> layer, as devices are becoming high-latency high-bandwidth, compared to
> what MTD was designed for.  In order to get any decent performance, we
> need asynchronous operations, request queues and caching.
>
> The only useful advantage MTD does have over block devices is an
> _explicit_ erase operation.  Did you mean "doesn't do _implicit_ erase".


You're right.  That the point I was trying to make, albeit badly, MTD
isn't the place for this.  The fact that more and more of what the MTD
is being used for looks a lot like the block layer is a whole
different discussion.
