Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbZBKWHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbZBKWHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZBKWHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:07:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZBKWHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:07:16 -0500
Message-ID: <49934C01.8000309@zytor.com>
Date: Wed, 11 Feb 2009 14:06:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: pass in pt_regs pointer for syscalls that need it
 (take 2)
References: <1234277507-4987-3-git-send-email-brgerst@gmail.com> <1234388638-13663-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1234388638-13663-1-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> Some syscalls need to access the pt_regs structure, either to copy
> user register state or to modifiy it.  This patch adds stubs to load
> the address of the pt_regs struct into the %eax register, and changes
> the syscalls to take the pointer as an argument instead of relying on
> the assumption that the pt_regs structure overlaps the function
> arguments.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Testing this now, together with the do_rt_sigreturn -> sys_rt_sigreturn 
change.  If it works okay I'll commit it as an incremental diff to 
tip:core/percpu.

	-hpa
