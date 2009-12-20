Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZLTCH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZLTCH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 21:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbZLTCHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 21:07:25 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:46061 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbZLTCHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 21:07:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nlP7X2p+Zg4ZNWpO6I14IK7FPYZKp9nDUFahTfP9U0jh5NGVL4P2zHQY7ZLs5t+tyY
         2HEdMvxKoCQ2S1dlYC5ZJIqrJOELG+3fNTsAIRQxHt5bt4tttDxgryEJSBKZuUW20SS9
         bnhp9rUlrpjqD0YIRMA82GfPEHMAdi5ffihtA=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.01.0912191405460.12202@filesrv1.baby-dragons.com>
References: <alpine.LNX.2.01.0912181147200.9874@filesrv1.baby-dragons.com>
	 <c32efac40912190113i5292a395tcc257c16a4870f3b@mail.gmail.com>
	 <alpine.LNX.2.01.0912191405460.12202@filesrv1.baby-dragons.com>
Date: Sat, 19 Dec 2009 18:07:24 -0800
Message-ID: <c32efac40912191807o7f7b7c2dw2259721e6c0635f6@mail.gmail.com>
Subject: Re: drivers/gpu/drm/radeon/radeon_test.c:45: undefined reference to 
	`__udivdi3'
From: Dave Hylands <dhylands@gmail.com>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev@vger.kernel.org,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

>        Thank you ,  For replying .  Now I being a kernel level nothing ,
>  How does this help me get past the 'ld' time undefined reference ?  So we
> can have a kernel build complete (hopefully) successfully .
>
>        I've another ? as well how is it that the drm/radeon_test.c is using
> (well at least referencing) a non-kernel symbol ?  That alone is rather
> interesting .
>
>        But all I had to do is Disable DRM in the kernel .  Since this system
> is a remote device without a real need for DRI/DRM support that should cure
> my problem .  But someone else is going to need that support & I am sure
> they'll hit that same bug .

I'm not familiar with the source code in question, but presumably,
someone will need to change the source to remove the 64-bit divide and
do it using the do_div macro or something equivalent.

-- 
Dave Hylands
Shuswap, BC, Canada
http://www.DaveHylands.com/
