Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbXA1VqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbXA1VqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932912AbXA1VqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:46:20 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:42787 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895AbXA1VqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:46:19 -0500
Date: Sun, 28 Jan 2007 22:45:33 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Raid 10 question/problem [ot]
In-Reply-To: <45BCFD10.4070302@tls.msk.ru>
Message-ID: <Pine.LNX.4.61.0701282241190.22295@yvahk01.tjqt.qr>
References: <593246.19408.qm@web52505.mail.yahoo.com>
 <Pine.LNX.4.61.0701271931260.22295@yvahk01.tjqt.qr> <45BC6740.1000606@tls.msk.ru>
 <Pine.LNX.4.61.0701281327180.22295@yvahk01.tjqt.qr> <45BCFD10.4070302@tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 28 2007 22:44, Michael Tokarev wrote:
>>> Mdadm creates those nodes automa[tg]ically - man mdadm, search for --auto.
>> 
>> Note that `mdadm -As` _is_ run on FC6 boot.
>
>See above -- man mdadm, search for --auto.  -A = --assemble, -s = --scan.

Oops, thank you. So....

  mdadm -A -s --auto=yes

did the right thing, and probably is what was intended. And now for
tonight's 1000$ question: why does fedora don't do that, making me edit
the mdadm -A -s line in /etc/rc.d/rc.sysvinit?


	-`J'
-- 
