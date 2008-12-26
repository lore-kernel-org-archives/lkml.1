Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYLZXtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYLZXtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 18:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYLZXtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 18:49:23 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:40794 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYLZXtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 18:49:23 -0500
Message-ID: <00aa01c967b4$8ffc2350$6602a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <davidsen@tmr.com>
Cc: <linux-kernel@vger.kernel.org>, "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: [PATCH] Compress kernel modules on installation
Date: Sat, 27 Dec 2008 00:49:15 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Provags-ID: V01U2FsdGVkX1+FiNk90jmOyv0MQDPs+IsG4m8nX4eGtZqzvAdB
	2FLZswtQYkGfpAZzF0fjXFdWe3cY9HCdzyGW8i96Iw6le7F1sF
	MrqeZURHE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> what about some "make modules_install_compressed" instead ?
> >>>
> >>> as i have run out of diskspace quite often when installing test
> >>> kernels, i
> >>> think we really need a feature like this.
> >>>
> >>> i`d also favour the makefile approach.
> >>> why another kconfig option?
> >>>
> >>> jan`s patch looks clean and simple, but i think it`s a little bit
> >>> intrusive...
> >>
> >> Why so? module-ini
> >
> > with "intrusive" i meant, that all modules are now compressed by default
> > and there is no switch to build them uncompressed.
> > so you change a long established default which may not be welcomed by
> > everyone and give no option for conservative people.
> >
> How many people use the option to install an uncompressed kernel?


i don`t know, probable few to none on pc/server hardware, but things may 
look different in embedded sector...


btw, here is some real-world data on compression and block-alignment:


kernel 2.6.27.8

                               (du -sk)      (du -sk --apparent-size)
uncompressed          72140         66554
gzip                          29988         25447
gzip -9                      29892         25374

roland

