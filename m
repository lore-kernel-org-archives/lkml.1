Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbXA2Wip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbXA2Wip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXA2Wip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:38:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:40038 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbXA2Win (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:38:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rs57ADN/uIcDAIvc0y/OEXQgeMCGy69CU3KM5W9EqK57mvM5RMakm47zFZRlUZVA8Gu3DjkQ3xiT0ilnJvDeP/o5WjTwn6MJvCuN9Nksvu5cj9mFb3KXqc5hM9sYJpZWq8cNsiv0hqS/PgDcgxL8htddBvAem2S264EzLwXjuNM=
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: tglx@linutronix.de
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <1170109401.29240.49.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169931333.17469.125.camel@localhost.localdomain>
	 <20070129113159.7ad22e4c@freekitty>
	 <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Mon, 29 Jan 2007 23:38:38 +0100
Message-Id: <1170110318.21603.25.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 janvier 2007 à 23:23 +0100, Thomas Gleixner a écrit :
> On Mon, 2007-01-29 at 13:38 -0800, Stephen Hemminger wrote:
> > Sorry it was against the last patch I sent to Jeff for netdev.
> > Here is against 2.6.20-rc6
> 
> Still the same problem. The only difference of this patch to the
> previous version is, that the unhandled interrupt message is gone.
> 
> As I said before:
> 
> Reverting commit 44ade178249fe53d055fd92113eaa271e06acddd, which added
> this hackery in the first place, makes the device survive
> suspend/resume.

I see the same symptoms on my Intel Mac Mini, and reverting the commit
also allows the driver to seemingly resume correctly. 

However after coming out of sleep I need to reconfigure the network
interface. No need to rmmod/insmod, just ifdown/ifup is sufficient (but
of course shouldn't be necessary, should it?). If I don't reconfigure
it, ping from/to the box will work, but nothing more complicated like
ssh will go through.

Fred.

