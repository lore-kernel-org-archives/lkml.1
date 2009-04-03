Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbZDCGAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbZDCGAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZDCGAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:00:40 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:37404 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZDCGAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:00:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u8gG3GY7Gx0+/QrqB+//H+3i0yWXbJDNDBMqeNehTnh0jIN50amDgIYyBcZVSkd1RX
         ss+tfLnpgFlvPTp7U2bDGPj7Sra2deaiPjf82WgS8al7NXhGBpf+bs40J88zVQ2gDS+X
         UfUzjQQP61KHV7v9VIuURTqcWohoYMfDTjViE=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.0902191415220.14749@vixen.sonytel.be>
References: <1234972402-24298-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <6934efce0902181624q57f3423dm50cda218781e4399@mail.gmail.com>
	 <alpine.LRH.2.00.0902191415220.14749@vixen.sonytel.be>
Date: Thu, 2 Apr 2009 23:00:36 -0700
Message-ID: <6934efce0904022300if85bc59ue2945dc1674902c1@mail.gmail.com>
Subject: Re: [PATCH 5/5] squashfs: Make SquashFS 4 use the new pcomp crypto 
	interface
From: Jared Hulbert <jaredeh@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I just saw this email.  My kernel hacking time has been rudely
interrupted by other important work.

> How's AXFS going?

It's doing pretty well, we just haven't had time to push hard enough
to get it out.  It's been fairly stable for us for a while.

Now I'm anxious to get it more widely tested.  I've got two vexing bug
reports.  1) a mips consumer platform where the main app can't operate
in XIP, but everything else can.  2) Just yesterday we found Android
APK's don't like to be XIP.  These look more like flaws in the
filemap_xip.c than AXFS bugs.  Fortunately there was bug fix that went
out just a couple days ago.  I'm hoping it will fix our problems.

We've automated a great deal of the busy work associated with testing
and deploying it, so now I just need to find a couple days a week for
a few weeks.

Our flagship customer went a different direction, so it's been hard to
justify time to work on it.

> BTW, you probably want to read the full patch series, including the
> introduction :-)

Yes, I saw that shortly after I clicked "send". :)
