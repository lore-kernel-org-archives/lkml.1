Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZFRWn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZFRWn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZFRWnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:43:21 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:51865 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZFRWnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:43:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19002.44369.638997.584055@cargo.ozlabs.ibm.com>
Date: Fri, 19 Jun 2009 07:10:41 +1000
From: Paul Mackerras <paulus@samba.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 5/6] perf_counter: powerpc: Add processor back-end for MPC7450 family
In-Reply-To: <E57BFC08-F847-463A-9D0F-55979C4B0524@kernel.crashing.org>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
	<19000.55631.802122.696927@cargo.ozlabs.ibm.com>
	<34BD6A89-A05E-40CC-A495-017BFB08B796@kernel.crashing.org>
	<19001.31508.901222.288946@cargo.ozlabs.ibm.com>
	<E57BFC08-F847-463A-9D0F-55979C4B0524@kernel.crashing.org>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala writes:

> In looking at doing this what suggestions do you have in implementing  
> perf_instruction_pointer() if we don't have the equivalent of SIAR.   
> Just use regs->nip ?

Yes, exactly.  If you don't have SIAR/SDAR/MMCRA, the default
definitions for perf_instruction_pointer and perf_misc_flags in
include/linux/perf_counter.h are fine, and you get them if
perf_misc_flags is not defined.

Paul.
