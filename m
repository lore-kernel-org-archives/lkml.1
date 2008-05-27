Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbYE0PlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbYE0PlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbYE0PlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:41:13 -0400
Received: from www.tglx.de ([62.245.132.106]:51684 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbYE0PlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:41:11 -0400
Date: Tue, 27 May 2008 17:40:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: fix broken math-emu with lazy allocation of fpu
 area
In-Reply-To: <20080523232637.GF18385@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0805271740100.3295@apollo.tec.linutronix.de>
References: <20080523232637.GF18385@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008, Suresh Siddha wrote:

> Fix the math emulation that got broken with the recent lazy allocation of FPU
> area. init_fpu() need to be added for the math-emulation path aswell
> for the FPU area allocation.
> 
> math emulation enabled kernel booted fine with this, in the presence
> of "no387 nofxsr" boot param.

Applied and queued for Linus. Thanks,

	tglx
