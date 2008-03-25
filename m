Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYCYPdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYCYPdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYCYPdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:33:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:50234 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbYCYPdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:33:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=UzYiur/dr2tZnQirBudbYbJnxsg+7rFRZpaye32Kt064nNKushW/rhdilpOg8q05l8Gc4nEYKUrOGfTtK++WsSQRswcwUWNnjwYbeULrkMFRfe81HXFYia3MAeXK+laglA0Snqxbnbeyx4CafkDRJz8EHrCUceHtSPLkiQALo8Q=
Date: Tue, 25 Mar 2008 16:08:48 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Spammed logs again rt2500pci 2.6.25-rc6-00268-gd2532dd
Message-ID: <20080325160848.6dc3584f@Varda>
In-Reply-To: <200803251441.22394.IvDoorn@gmail.com>
References: <20080117225744.29aa214c@Varda>
	<20080325131250.5167e311@Varda>
	<200803251441.22394.IvDoorn@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 25 Mar 2008 14:41:22 +0100
Ivo van Doorn <ivdoorn@gmail.com> escribió:

> Hi,
> 
> >  Linux Varda 2.6.25-rc6-00268-gd2532dd #1 SMP PREEMPT Mon Mar 24 14:44:13 CET
> > 2008 x86_64 GNU/Linux
> > 
> > 
> >  As the last time the thing is triggered with a p2p app making a lot of
> >  connections deluge
> >  
> >  My logs are spammed with the same msgs as other reports.
> >  If you need more info just ask.
> 
> This issue has been resolved for 2.6.26. The fix for this bug is of such a scale
> that it could not easily be merged for 2.6.25.
> 
> >  PS: i will not bother to make a report in the web forums becouse the last time
> > i was ignored.
> 
> You mean http://rt2x00.serialmonkey.com/phpBB2/index.php?
> 'ignored' is not the right word, more likely overlooked.

 Fair enough; english is not my mother tongue so maybe i sounded
harsher than intended. If that's the case my apologies

> There are quite a lot of messages and I don't always have time to answer them all.
> So there is no need to be upset about such thing, simply posting a reminder is usually
> enough to make it noticed by me...
> 
> > (Someone may want to change the web forums pointer in the logs to 
> > the linux-wireless mailing list)
> 
> What pointer? And rt2400-devel is the mailinglist for rt2x00...
> The MAINTAINERS file in the kernel tree indicates 2 mailinglists for rt2x00:
> 	rt2400-devel@lists.sourceforge.net
> 	linux-wireless@vger.kernel.org

 Well my opinion is that instead of the webpage the mailing list should be the
one being logged. Something like this (maybe use another define becouse
DRV_PROJECT may be used elsewhere i havn't checked):

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h
b/drivers/net/wireless/rt2x00/rt2x00.h index 6c72542..2791f67 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -44,7 +44,7 @@
  * Module information.
  */
 #define DRV_VERSION	"2.0.14"
-#define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
+#define DRV_PROJECT	"<rt2400-devel@lists.sourceforge.net>"
 
 /*
  * Debug definitions.



> 
> Ivo

