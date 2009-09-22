Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbZIVXHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbZIVXHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZIVXHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:07:14 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:38105 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751556AbZIVXHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:07:10 -0400
Date: Tue, 22 Sep 2009 18:52:31 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] vmalloc: rename local variables vmalloc_start and
 vmalloc_end
In-Reply-To: <1253605214-23210-2-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.1.10.0909221851380.9410@V090114053VZO-1>
References: <1253605214-23210-1-git-send-email-tj@kernel.org> <1253605214-23210-2-git-send-email-tj@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Tejun Heo wrote:

>   const unsigned long vmalloc_end = vmalloc_end & ~(align - 1);
>
> Rename local variables vmalloc_start and vmalloc_end to vm_start and
> vm_end to avoid the collision.

Could you keep vmalloc_end and vmalloc_start? vm_start and vm_end may led
to misinterpretations as start and end of the memory area covered by the
VM.

