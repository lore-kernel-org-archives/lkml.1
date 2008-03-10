Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYCJTU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYCJTU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYCJTUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:20:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYCJTUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:20:19 -0400
Message-ID: <47D589B9.1080109@redhat.com>
Date: Mon, 10 Mar 2008 15:19:21 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ptrace orig_ax on ia32 task
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080307225602.6491B26F990@magilla.localdomain>
In-Reply-To: <20080307225602.6491B26F990@magilla.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2008 05:56 PM, Roland McGrath wrote:
> This makes 64-bit ptrace calls setting the 64-bit orig_ax field
> for a 32-bit task sign-extend the low 32 bits up to 64.  This
> matches what a 64-bit debugger expects when tracing a 32-bit task.
> 
> This follows on my "x86_64 ia32 syscall restart fix".
> This didn't matter until that was fixed.
> 

That original patch is still unmerged as of -rc5.

