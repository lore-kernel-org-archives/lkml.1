Return-Path: <linux-kernel-owner+w=401wt.eu-S1751521AbZKCGnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbZKCGnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 01:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZKCGnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 01:43:50 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61381 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbZKCGnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 01:43:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=xNOlt9mNWsq0zg+w8Z4kyWFwFGhdjkNj1urL6ugmHy6B33bQjPVgavBcNQt94fzs+E
         SdaPplWVfpGD2a0EKqRWiw+Zt+iQsqM7EMNOllPFFZB0jaBSv6kp5M7hrUXko7uxb90/
         oCjj76yvj1NEZJNV3zh2igZlol7pAwXnFsMmA=
Date: Tue, 3 Nov 2009 07:43:47 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       bluesmoke-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/14] cpumask: use modern cpumask style in
 drivers/edac/amd64_edac.c
Message-ID: <20091103064347.GA8082@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
	Doug Thompson <dougthompson@xmission.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	bluesmoke-devel@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>
References: <200911031456.35354.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200911031456.35354.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 03, 2009 at 02:56:35PM +1030, Rusty Russell wrote:
> cpumask_t -> struct cpumask, and don't put one on the stack.  (Note: this
> is actually on the stack unless CONFIG_CPUMASK_OFFSTACK=y).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

I've got a similar patch already queued up but it
depends on the changes to rdmsr_on_cpus/wrmsr_on_cpus in
b8a4754147d61f5359a765a3afd3eb03012aa052 which is in tip/x86/cpu and
which does a bit more than your patch 4 so IMHO you could drop yours.

Concerning the edac change, yours is better and I could pick it up and
add it to my patch queue if nobody else has a problem with that?

-- 
Regards/Gruss,
    Boris.
