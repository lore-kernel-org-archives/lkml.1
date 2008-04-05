Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbYDEFo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbYDEFo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 01:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYDEFot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 01:44:49 -0400
Received: from n77.bullet.mail.sp1.yahoo.com ([98.136.44.45]:46348 "HELO
	n77.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750843AbYDEFot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 01:44:49 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 426993.49257.bm@omp402.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hypEPpHW+LzRcx/r/LcXqc4ASKU89tZN7b06Ngb/jOM+tJ1HwzCYxAweCf0Kpu1aDQpaPTFeNkyyUbF8Vbyb3oEXi8BC1NcHY6d2NXKb7ksxE0uDxpNwWlqoRZSnkTzZtcX4whDe+JRb2xNLqiESCG0FrbtNRbWjvxM/vYjhSN8=;
X-YMail-OSG: I3xK6kQVM1lAt.p8D0FwmiTyxJoh5MWViJOomdVPvB3bkZHkow3SSSPqwaono4Q3Ez.NVJP3DTC2ryw0OHTzZJi3cT8OH0HrrKDJ
Date: Sat, 5 Apr 2008 02:44:48 -0300 (ART)
From: Luis Sousa <ls.luis_sousa@yahoo.com.br>
Subject: Re: sata io freeze, 2.6.18 and also 2.6.24
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <231034.25568.qm@web46015.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Luis Sousa <ls.luis_sousa@yahoo.com.br> escreveu:
> 
> --- Luis Sousa <ls.luis_sousa@yahoo.com.br> escreveu:
> 
> > --- Jeff Garzik <jeff@garzik.org> escreveu:
> > 
> > > Luis Sousa wrote:
> > > > I've been having consistent hard system freezes for a
> > > > long time, every 2 days or so, and finally decided to
> > > > move to the most recent stable kernel. Unfortunatelly
> > > > that didn't fix it. The freezes seem to be io-related;
> > > > they started since I moved my drive to sata. They seem
> > > > to happen mostly when there's an io-intensive operation,
> > > > like extracting a big archive; a reboot is needed.
> > > 
> > > We need more info, namely full 'dmesg', 'lspci -v', and your kernel config.
> > > 
> > > Also, make /sure/ you are not running closed-source modules known to 
> > > crash the system, like ndiswrapper or nvidia graphics driver.
> > > 
> > > 	Jeff
> > 
> > I'm quite sure.

It seems I have a failing RAM problem. I ran memtest86+ and got lots of
errors in test #7 (random number sequence), in the whole address space.

Looks like that might be the cause of the lockups and also some weird
kernel oops'es which I've been experiencing.

I'll try fixing that and if it still keeps crashing, I'll be in touch.

--
Luis Sousa


      Abra sua conta no Yahoo! Mail, o único sem limite de espaço para armazenamento!
http://br.mail.yahoo.com/

