Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab0CNLvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 07:51:44 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35423 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab0CNLvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 07:51:41 -0400
X-Auth-Info: sLhHWpfDB2DGGD9szitozaGMQTk0CBV/PZ5RtQkyXsg=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.34-rc1: Badness at fs/proc/generic.c:316
References: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
	<20100314065526.GA5353@x200>
	<alpine.DEB.2.01.1003140336280.5493@bogon.housecafe.de>
	<20100314112428.GA4142@x200>
	<alpine.DEB.2.01.1003140431040.5493@bogon.housecafe.de>
X-Yow: NEWARK has been REZONED!!  DES MOINES has been REZONED!!
Date: Sun, 14 Mar 2010 12:51:38 +0100
In-Reply-To: <alpine.DEB.2.01.1003140431040.5493@bogon.housecafe.de>
	(Christian Kujau's message of "Sun, 14 Mar 2010 04:46:07 -0700 (PDT)")
Message-ID: <m2tysjw27p.fsf@whitebox.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau <lists@nerdbynature.de> writes:

> On Sun, 14 Mar 2010 at 13:24, Alexey Dobriyan wrote:
>> Post "find /proc/device-tree" output.
>
> I did upload[0] a tarball of /proc/device-tree, please see below the 
> "find" output.
>
> Indeed, there's a /cpus/PowerPC,G4@0/l2-cache and 
> /cpus/PowerPC,G4@0/l2-cache#1 in the device-tree. However, from looking at 
> the logfiles, the
>
>    device-tree: Duplicate name in /cpus/PowerPC,G4@0, renamed to "l2-cache#1"

That's a red herring, the real problem is this:

name 'pulses/rev'

Of course, this name cannot be found in /proc/device-tree, because it
wasn't created.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
