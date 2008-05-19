Return-Path: <linux-kernel-owner+w=401wt.eu-S1765029AbYESWGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765029AbYESWGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbYESWEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:04:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758852AbYESWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:04:29 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Weird Xorg stretching (setfont)
To: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@gmail.com>, Chris Snook <csnook@redhat.com>
Reply-To: 7eggert@gmx.de
Date: Tue, 20 May 2008 00:03:40 +0200
References: <atMjN-4Qh-19@gated-at.bofh.it> <atPB7-2Ai-23@gated-at.bofh.it> <atTlj-1SF-3@gated-at.bofh.it> <atUU6-4Xh-15@gated-at.bofh.it> <auaw7-1tZ-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JyDSG-0003g7-Kd@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/kjBF/bUYeO8kapcSz+oOyZTc12zvDhxiX3/V
 MYCK8ryj7c5hg2fF+DccaI2jD26kIG84jvoan/phTD40DwG7FR
 t2ZcNMRb4xGVO9z63pcNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> Dave Airlie wrote:

>> wierd got any fglrx or anything installed on you're system.. the
>> radeon drm hasn't seen any changes that should affect this sorta
>> thing, do you run radeonfb or vesafb?
> 
> Just in case you didn't see my reply I'm not an fglrx user and I don't run
> radeonfb or vesafb.
> 
> After testing far too many kernels it turns out that this is not a
> conventional regression. During startup openSUSE runs the following
> command:
> 
> /bin/setfont -C /dev/tty1 lat9w-16.psfu -m trivial
> 
> in /etc/init.d/kbd
> 
> Now on the openSUSE provided 2.6.22.17-0.1-default #1 SMP kernel if X has
> started and your run that command (e.g.
> chvt 7; sleep 5s && /bin/setfont -C /dev/tty1 lat9w-16.psfu -m trivial
> ) the command will fail with error output similar to the following:
> setfont: putfont: 256,8x16: failed: -1
> putfont: KDFONTOP: Invalid Argument
> 
> If you are using a stock kernel (e.g. 2.6.24/2.6.25 etc) the command will
> not fail and will instead corrupt X causing the lower part of the screen to
> be drawn using the same line (creating a stretch/mirror effect).

I see a similar effect on my "GeForce2 MX/MX 400" using the "nv" driver.
The difference is: I see both the screen corruption and (from ssh):
be10:/etc/init.d # ./kbd start
Loading keymap qwertz/de-latin1-nodeadkeys.map.gz                    done
Keyboard: Typematic Rate set to 30.0 cps (delay = 250 ms)            done
Loading compose table latin1.add                                     done
Stop Unicode mode
kbd_mode not called for /dev/pts/1                                   done
Loading console font lat9w-16.psfu  -m trivial (K
putfont: PIO_FONT: Invalid argument                                  failed
be10:/etc/init.d #


