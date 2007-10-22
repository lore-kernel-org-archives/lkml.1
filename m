Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbXJVJg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbXJVJg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbXJVJgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:36:51 -0400
Received: from il.qumranet.com ([82.166.9.18]:32986 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbXJVJgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:36:50 -0400
Message-ID: <471C6F04.20004@qumranet.com>
Date: Mon, 22 Oct 2007 11:36:04 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 00/11] KVM updates for Linux 2.6.24-rc review
References: <1192964892617-git-send-email-avi@qumranet.com>	<471B340C.5010800@qumranet.com> <471B3DD3.3080107@bull.net> <471B40E4.4060204@qumranet.com> <471B483D.90305@bull.net>
In-Reply-To: <471B483D.90305@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
>
> Well, in fact it is not needed in 2.6.24, because this patch correct a 
> bad behavior introduced by commit 
> 57f4e446ebca4aad5c11364baf8477c8cfcb16a4 (which is not in 
> kvm-update-2.6.24):
>
> KVM: Call x86_decode_insn() only when needed
>
> Move emulate_ctxt to kvm_vcpu to keep emulate context when we exit 
> from kvm
> module. Call x86_decode_insn() only when needed. Modify 
> x86_emulate_insn() to
> not modify the context if it must be re-entered.
>
> So, in fact, the answer is (after correctly understanding the 
> question): no, this patch is not needed in kvm-update-2.6.24.



Thanks.  I've folded it into 57f4e446ebca4aad5c11364baf8477c8cfcb16a4 
for 2.6.25.

-- 
error compiling committee.c: too many arguments to function

