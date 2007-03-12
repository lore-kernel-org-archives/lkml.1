Return-Path: <linux-kernel-owner+w=401wt.eu-S1030259AbXCLOxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbXCLOxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030299AbXCLOxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:53:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:9479 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030259AbXCLOxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GGfbwch2O9lyN1/dPVYF62uJ0QOCR3jnBX6piRJG//rgGE8qnL2v5xX4Gzh/UIHSU4LCcf6YGecIeoXEzpaK/Qm2OT71SZLUkw4LsaruBsApsHpjsiUdy7O0M2TA/1VkLIVgEN4ap2q5BmMdLmo4WHiQ4MRA+PCXHeYMNsy1ry8=
Message-ID: <a790ea7a0703120753i232ace2bg7272fa479b821e32@mail.gmail.com>
Date: Mon, 12 Mar 2007 15:53:18 +0100
From: "Antonio Mignolli" <antoniomignolli@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: lid switch hangs notebook
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm running a slackware 10.2 on a HP/Compaq nx5000.

With kernels <= 2.6.17.3 I didn't have problems.
Starting from 2.6.19 if I close the notebook's video,
or if I press the lid switch,
after a couple of time, or after a few seconds, the o.s. hangs
completely. The only thing to do is a brute power off
by pressing for 5 seconds the power button
(If I press for few it should do a clean shutdown -h).
I've tried 2.6.19, 2.6.19.1, 2.6.19.2, 2.6.20, 2.6.20.1, 2.6.20.2,
and all of them seem to give problems.

I don't have KERNEL_DEBUG set, so I haven't any debug informations,
I will be happy to activate it and provide more info if someone suggests
me which debug parameters I should set.
There's nothing in /var/log/messages and /var/log/syslog,
except for the message "LID switch" added by me
with a logger command in /etc/acpi/acpi_handler.sh.
I've put it after noticing the problem, in order to be sure the event was
detected, and it was.
