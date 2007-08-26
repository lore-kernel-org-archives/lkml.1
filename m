Return-Path: <linux-kernel-owner+w=401wt.eu-S934946AbXHZCh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946AbXHZCh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 22:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933980AbXHZChT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 22:37:19 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:48230 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934050AbXHZChR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 22:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=T+tNX71zXzhyhdACYyMl21Hf1kEWomfBA5HhVde1Ti8U9sWCknY153UKUQuiuUjo5ir/OsVRCAgGYzGpgOqTBMT57oqvghtDvagBbadDQCZApWBl3mgwEjtTV5a7oJr6/l2DEvgCZfcOS8Cua3GsXIltByTgsp40lcrjsdoQOls=
Message-ID: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com>
Date: Sat, 25 Aug 2007 23:37:16 -0300
From: "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@gmail.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org
Subject: Sleep problems with kernels >= 2.6.21 on powerpc
Cc: "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Unfortunately, it seems that kernels later than 2.6.21 have problems
letting my powerpc iBook (G3 processor) going to sleep (suspend to
ram).

The userland that I am using is a Debian testing (lenny) and the
default kernel that comes with it is 2.6.22, with some patches applied
and pbbuttonsd (as the daemon for making the machine sleep).

With kernel 2.6.21, from Debian (and other earlier kernels), the
symptoms that I see when I press the power button is that the machine
goes to sleep and the led that indicates that the machine is sleeping
is blinking normally.

If I, on the other hand, use Debian's kernel 2.6.22 or compile my own
kernel with just the necessary parts for my work (version 2.6.23-rc3
taken from kernel.org), then I can't make the machine sleep: when I
press the button, it acts like if I had, in sequence, pressed anything
to wake it up (say, like pressing shift).

I have already grabbed Linus's git tree and I am willing to do some
cycles of "git bisect" to discover the point where it stopped working.

I just thought that others may have seen such behaviour before or, if
not, that being informative about what I see is of use for debugging
this.

I would also appreciate any guidance on this as I wish kernel 2.6.23
to be working again on powerpc machines.

Please, if any tests are required, don't hesitate to ask me and I will
try to whatever is needed to restore the correct behaviour of sleep
with the Linux kernel.

I have copied mailing lists that I think that are relevant. If they
aren't, then please let me know. I would also appreciate if I were
kept on carbon copies as I am only subscribed to debian-powerpc at the
moment.


Regards, Rogério Brito.

P.S.: It unfortunately doesn't matter if I switch to a console or if I
am in X when I press the power button with recent kernels.
