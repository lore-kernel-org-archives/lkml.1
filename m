Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbXEESox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbXEESox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbXEESox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:44:53 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41339 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbXEESox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:44:53 -0400
Date: Sat, 5 May 2007 20:42:18 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463CC380.3060603@interia.pl>
Message-ID: <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> 
 <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com>
 <463CC380.3060603@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 5 2007 19:48, Rafał Bilski wrote:
>
>I found one line which wasn't were it should be. Probably this will not 
>fix Your problem with powersave governor, but it is a bit related. 
>Looks like Longhaul isn't skipping frequency transtition when it is asked 
>to set f which is already set. Now after first transition it will not 
>try to set same frequency again. Second part contains some magic 
>because I don't have CN400 datasheet. It is NDA protected :-( Should 
>print You one byte in hex and will try to set one register. I don't 
>know if anything will change but it is worth testing.

Did not help unfortunately. The output the printk line generated was
  longhaul: 0x0

(Strangely enough, %#02x with glibc outputs "00", not "0x0".
And I would have expected "0x00". Subtleties of the kernel 
printk/glibc?)



Jan
-- 
