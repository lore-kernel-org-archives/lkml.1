Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYG2E5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYG2E5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYG2E5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:57:32 -0400
Received: from ozlabs.org ([203.10.76.45]:47954 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbYG2E5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:57:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [rfc git pull] cpus4096 fixes, take 2
Date: Tue, 29 Jul 2008 11:45:19 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org> <20080728205700.GA3613@elte.hu>
In-Reply-To: <20080728205700.GA3613@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291145.20231.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 06:57:00 Ingo Molnar wrote:
> +/*
> + * In cases where we take the address of the cpumask immediately,
> + * gcc optimizes it out (it's a constant) and there's no huge stack
> + * variable created:
> + */
> +#define cpumask_of_cpu(cpu) ({ *get_cpu_mask(cpu); })

Why use a statement expression here?  Isn't (*get_cpu_mask(cpu)) sufficient?

Cheers,
Rusty.
