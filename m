Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbYDNVIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbYDNVIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYDNVIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:08:31 -0400
Received: from ns1.suse.de ([195.135.220.2]:45066 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbYDNVIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:08:31 -0400
From: Andreas Schwab <schwab@suse.de>
To: Christian Schmidt <lkml@digadd.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ptrace (PTRACE_GETREGS, ...) discrepancy for x86 emulation on x86_64?
References: <4803BCD3.9020205@digadd.de>
X-Yow: ..  Now I think I just reached the state of HYPERTENSION that comes
 JUST BEFORE you see the TOTAL at the SAFEWAY CHECKOUT COUNTER!
Date: Mon, 14 Apr 2008 23:08:27 +0200
In-Reply-To: <4803BCD3.9020205@digadd.de> (Christian Schmidt's message of
	"Mon, 14 Apr 2008 22:21:39 +0200")
Message-ID: <je4pa45elw.fsf@sykes.suse.de>
User-Agent: Gnus/5.110008 (No Gnus v0.8) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Schmidt <lkml@digadd.de> writes:

> So GS is still set (somewhere), though not defined for userspace. Am I
> correct, and should I fix my includes? After uncommenting the "int xgs;"
> above the program works.

You are using the wrong structure.  The right one is struct
user_regs_struct defined in <sys/user.h>.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
