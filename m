Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZBSARc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZBSARc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZBSARX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:17:23 -0500
Received: from ozlabs.org ([203.10.76.45]:47834 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZBSARX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:17:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/10] percpu: kill percpu_alloc() and friends
Date: Thu, 19 Feb 2009 10:47:18 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com, mingo@elte.hu
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-7-git-send-email-tj@kernel.org>
In-Reply-To: <1234958676-27618-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191047.19489.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 22:34:32 Tejun Heo wrote:
> Impact: kill unused functions
> 
> percpu_alloc() and its friends never saw much action.  It was supposed
> to replace the cpu-mask unaware __alloc_percpu() but it never happened
> and in fact __percpu_alloc_mask() itself never really grew proper
> up/down handling interface either (no exported interface for
> populate/depopulate).
> 
> percpu allocation is about to go through major reimplementation and
> there's no reason to carry this unused interface around.  Replace it
> with __alloc_percpu() and free_percpu().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Nice patch.  FWIW, Acked-by: Rusty Russell <rusty@rustcorp.com.au>

(Oh, and your other mods were acked as well, for the record).

Thanks!
Rusty.
