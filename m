Return-Path: <linux-kernel-owner+w=401wt.eu-S933831AbYD1Lq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831AbYD1Lq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764865AbYD1LqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:46:18 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:23024
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763564AbYD1LqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:46:17 -0400
Message-ID: <4815B907.5060101@qumranet.com>
Date: Mon, 28 Apr 2008 14:46:15 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kvm: add statics were possible, function definition in
 lapic.h
References: <1209323653.14173.68.camel@brick>
In-Reply-To: <1209323653.14173.68.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Noticed by sparse:
> arch/x86/kvm/vmx.c:1583:6: warning: symbol 'vmx_disable_intercept_for_msr' was not declared. Should it be static?
> arch/x86/kvm/x86.c:3406:5: warning: symbol 'kvm_task_switch_16' was not declared. Should it be static?
> arch/x86/kvm/x86.c:3429:5: warning: symbol 'kvm_task_switch_32' was not declared. Should it be static?
> arch/x86/kvm/mmu.c:1968:6: warning: symbol 'kvm_mmu_remove_one_alloc_mmu_page' was not declared. Should it be static?
> arch/x86/kvm/mmu.c:2014:6: warning: symbol 'mmu_destroy_caches' was not declared. Should it be static?
> arch/x86/kvm/lapic.c:862:5: warning: symbol 'kvm_lapic_get_base' was not declared. Should it be static?
> arch/x86/kvm/i8254.c:94:5: warning: symbol 'pit_get_gate' was not declared. Should it be static?
> arch/x86/kvm/i8254.c:196:5: warning: symbol '__pit_timer_fn' was not declared. Should it be static?
> arch/x86/kvm/i8254.c:561:6: warning: symbol '__inject_pit_timer_intr' was not declared. Should it be static?
>
>   

Applied, thanks.


-- 
error compiling committee.c: too many arguments to function

