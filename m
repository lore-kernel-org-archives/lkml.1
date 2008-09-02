Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYIBGhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYIBGhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 02:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYIBGhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 02:37:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49334 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYIBGhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 02:37:24 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
From: Andi Kleen <andi@firstfloor.org>
References: <48BB2116.1060904@lwfinger.net>
	<alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>
	<48BC2A03.9000104@lwfinger.net>
	<alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809011500460.12958@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809020033060.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809011545020.12958@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809020117260.3243@apollo.tec.linutronix.de>
Date: Tue, 02 Sep 2008 08:37:22 +0200
In-Reply-To: <alpine.LFD.1.10.0809020117260.3243@apollo.tec.linutronix.de> (Thomas Gleixner's message of "Tue, 2 Sep 2008 01:24:45 +0200 (CEST)")
Message-ID: <87k5dvvysd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
>
> The whole ACPI code relies pretty much on PM_TIMER and as I said

The Linux ACPI code does not rely on PM_TIMER in any special ways AFAIK 
(except that it occasionally uses standard linux timer functions)
It merely discovers it for use by the other pmtimer users.

-Andi
-- 
ak@linux.intel.com
