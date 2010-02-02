Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0BBTTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:19:12 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:52557 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab0BBTTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:19:07 -0500
Date: Tue, 2 Feb 2010 20:19:19 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Christoph Hellwig <hch@lst.de>
Cc: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 9/14] mips: use generic ptrace_resume code
Message-ID: <20100202191919.GA542@linux-mips.org>
References: <20100202185755.GA3630@lst.de>
 <20100202185958.GI3630@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202185958.GI3630@lst.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 07:59:58PM +0100, Christoph Hellwig wrote:

> Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT and
> PTRACE_KILL.  
> 
> Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL
> which it previously wasn't which is consistent with all architectures
> using the modern ptrace code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
