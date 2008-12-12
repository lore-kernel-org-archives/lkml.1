Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbYLLTIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbYLLTIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYLLTIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:08:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56738 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYLLTIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:08:07 -0500
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: don't enable MCE after suspend/resume when system was booted with "nomce"
From: Andi Kleen <andi@firstfloor.org>
References: <20081212180650.GS19144@alberich.amd.com>
	<20081212180827.GT19144@alberich.amd.com>
Date: Fri, 12 Dec 2008 20:08:28 +0100
In-Reply-To: <20081212180827.GT19144@alberich.amd.com> (Andreas Herrmann's message of "Fri, 12 Dec 2008 19:08:27 +0100")
Message-ID: <87y6ylmcsz.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann <andreas.herrmann3@amd.com> writes:

> Impact: fix suspend/resume bug with MCE
>
> A suspend/resume cycle unconditionally enables MCE
> for the boot CPU if MCE is compiled into the kernel.
> I.e. even a system booted with "nomce" configures MCE for the boot CPU.
>
> This patch ensures that MCE is not turned on for systems booted with
> "nomce".

I have that fixed in a better way in

http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=commit;h=81c7af997dafbabad464ccefba89af2b247899da

I believe


-Andi

-- 
ak@linux.intel.com
