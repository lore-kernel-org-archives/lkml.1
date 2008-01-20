Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYATNXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYATNXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 08:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYATNWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 08:22:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:36626 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752672AbYATNWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:22:52 -0500
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 20 Jan 2008 14:22:50 +0100
From: "Lars Callenbach" <lars.callenbach@gmx.de>
In-Reply-To: <200801201143.23612.hpj@urpla.net>
Message-ID: <20080120132250.34100@gmx.net>
MIME-Version: 1.0
References: <20080119185520.208350@gmx.net> <200801200007.00125.hpj@urpla.net>
 <20080119234804.3c58c77b@lxorguk.ukuu.org.uk>
 <200801201143.23612.hpj@urpla.net>
Subject: Re: linux device ordering at boot time
To: Hans-Peter Jansen <hpj@urpla.net>, alan@lxorguk.ukuu.org.uk
X-Authenticated: #7374987
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19fuDFV3GdfoKwqfdC8+Nu/aB6XBAHvTskz0L8jlK
 FQBsqUnXwsi5v//usatftfPYjA8gqPdBjmcQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: EnygcxB/f2IsO9zhHGxoK+x4dWxlc1bi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I followed your discussion. I still have a problem. The workaround of Alan works fine from a technical point of view using mkinitramfs. Now the hardware is assigned to the right devices. But I have some commercial software that (somehow) determines the "setup" of the computer. After the mkinitramfs change this setup has changed and the software does not work any more. Unfortunately my previous running image does not work at the moment (same problem, maybe related to "grub"). 

Are there other "simple" workarounds? Are there some simple steps that can be used to change the setup?

>From my point of view the following might be a solution. A policy should define how  information related to kernel functionality and hardware can be determined over a long time period. This can be defined by kernel (and kernel related) developers, software vendors and linux distributors. It can be something similar to "udev should be part of any linux installation and use UUID as id".


Thank you very much for your hints,
   Lars


-- 
GMX FreeMail: 1 GB Postfach, 5 E-Mail-Adressen, 10 Free SMS.
Alle Infos und kostenlose Anmeldung: http://www.gmx.net/de/go/freemail
