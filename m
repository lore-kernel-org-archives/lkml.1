Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZG1JXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZG1JXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 05:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZG1JXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 05:23:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34498 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZG1JXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 05:23:35 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: NMI between switch_mm and switch_to
From: Andi Kleen <andi@firstfloor.org>
References: <19054.33655.297932.261580@cargo.ozlabs.ibm.com>
	<1248767472.6987.2806.camel@twins>
Date: Tue, 28 Jul 2009 11:23:34 +0200
In-Reply-To: <1248767472.6987.2806.camel@twins> (Peter Zijlstra's message of "Tue, 28 Jul 2009 09:51:12 +0200")
Message-ID: <87vdldgnzd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> We could use preempt notifiers (or put in our own hooks) to disable
> callchains during the context switch I suppose.

You can simply check if cr3 matches the current->mm page tables
and not dump if they are not.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
