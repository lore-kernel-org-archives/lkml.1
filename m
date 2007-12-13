Return-Path: <linux-kernel-owner+w=401wt.eu-S934123AbXLMWdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbXLMWdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934206AbXLMWdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:33:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:37558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934139AbXLMWdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:33:09 -0500
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
From: Andi Kleen <andi@firstfloor.org>
References: <20071214004442.5f9eba88@linux360.ro>
Date: Thu, 13 Dec 2007 23:33:07 +0100
In-Reply-To: <20071214004442.5f9eba88@linux360.ro> (Eduard-Gabriel Munteanu's message of "Fri\, 14 Dec 2007 00\:44\:42 +0200")
Message-ID: <p737ijigr8c.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro> writes:
>  
> +	force_amd_c1e	[KNL,SMP,HW,BUGS=X86-64]
> +			Don't disable C1E on AMD systems even if this means

The description/option is not correct. The mainline kernel never disables C1e.
Some distribution kernels and Xen do, perhaps you're confusing this 
with them.

You would rather need a "force_disable_c1e" option if anything.

Anyways this should be near all obsolete with forced HPET. With HPET
dynticks can be used even with C1e. So in most cases you can just
use hpet=force instead and get dynticks and C1e together.

-Andi
