Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbYA1RGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbYA1RGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYA1RGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:06:36 -0500
Received: from ns2.suse.de ([195.135.220.15]:52427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbYA1RGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:06:35 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH 4/5] x86: Add config variables for SMP_MAX
Date: Mon, 28 Jan 2008 18:00:24 +0100
User-Agent: KMail/1.9.6
Cc: Mike Travis <travis@sgi.com>, ioe-lkml@rameria.de,
       akpm@linux-foundation.org, mingo@elte.hu, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20080118183011.354965000@sgi.com> <479108C3.1010800@sgi.com> <20080128104520.e1e6c878.pj@sgi.com>
In-Reply-To: <20080128104520.e1e6c878.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281800.24780.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The problem in kernel/sched.c:isolated_cpu_setup() is an array of
> NR_CPUS integers:
> 
>     static int __init isolated_cpu_setup(char *str)
>     {
> 	    int ints[NR_CPUS], i;
> 
> 	    str = get_options(str, ARRAY_SIZE(ints), ints);
> 
> Since isolated_cpu_setup() is an __init routine, perhaps we could
> make that ints[] array static __initdata?

That or use alloc_bootmem / free_bootmem

-Andi
