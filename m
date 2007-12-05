Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbXLEAIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbXLEAIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXLEAIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:08:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:50448 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbXLEAIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:08:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mCIrKlcpLKHUyK0XkFLCNhDpg4foipw8S9j9pZwoKoyqUUbimKd/d961aY2zyTTPYrom6xpYyvDp38ORIyTSvbD3td0rtY/60mxG7T2mRV8+UeLNe/0204KGlvlG01KLR+eD89wPLeoP6cdyvZScysOBbmGuIgNtS1dXJYLsAyE=
Message-ID: <6934efce0712041608w2e25587n6b2d738fa0265d9d@mail.gmail.com>
Date: Tue, 4 Dec 2007 16:08:07 -0800
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: solid state drive access and context switching
Cc: "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071204232449.6148e152@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47548BF4.3010907@nortel.com>
	 <20071203230629.725f4c7a@the-village.bc.nu>
	 <6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
	 <20071204203536.2bf6d025@the-village.bc.nu>
	 <6934efce0712041354n47c11d6ckbc7f4aa1e7c85f@mail.gmail.com>
	 <20071204232449.6148e152@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 3:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Right.  The trend is to hide the nastiness of NAND technology changes
> > behind controllers.  In general I think this is a good thing.
>
> You miss the point - any controller you hide it behind almost inevitably
> adds enough latency you don't want to use it synchronously.

I think I get it.  We keep saying that it's the latency is too high.
I agree that most technologies out there have latencies that are too
high.  Again I ask the question, what latencies do we have to hit
before the sync options become worth it?
