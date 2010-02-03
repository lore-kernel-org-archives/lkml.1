Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0BCGzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 01:55:07 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:49961 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300Ab0BCGzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 01:55:04 -0500
Message-ID: <4B691DC1.8040503@snapgear.com>
Date: Wed, 03 Feb 2010 16:54:57 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 7/14] m68knommu: use generic ptrace_resume code
References: <20100202185755.GA3630@lst.de> <20100202185935.GG3630@lst.de>
In-Reply-To: <20100202185935.GG3630@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT,
> PTRACE_KILL and PTRACE_SINGLESTEP.  m68knommu already defines the
> nessecary user_enable_single_step and user_disable_single_step functions
> for this.
> 
> Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL
> which it previously wasn't which is consistent with all architectures
> using the modern ptrace code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Greg Ungerer <gerg@uclinux.org>


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
