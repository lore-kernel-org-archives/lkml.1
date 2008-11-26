Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYKZKy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYKZKy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 05:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYKZKys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 05:54:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56891 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYKZKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 05:54:47 -0500
Date: Wed, 26 Nov 2008 12:05:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 17/24] perfmon: X86 64-bit system calls support (x86)
Message-ID: <20081126110510.GP6703@one.firstfloor.org>
References: <492d0c02.02a1660a.15f1.ffffdbb5@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0c02.02a1660a.15f1.ffffdbb5@mx.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define __NR_pfm_create				295
> +__SYSCALL(__NR_pfm_create, sys_pfm_create)
> +#define __NR_pfm_write				(__NR_pfm_create+1)
> +__SYSCALL(__NR_pfm_write, sys_pfm_write)
> +#define __NR_pfm_read				(__NR_pfm_create+2)
> + __SYSCALL(__NR_pfm_read, sys_pfm_read)
> +#define __NR_pfm_attach				(__NR_pfm_create+3)
> +__SYSCALL(__NR_pfm_attach, sys_pfm_attach)
> +#define __NR_pfm_set_state			(__NR_pfm_create+4)
> +__SYSCALL(__NR_pfm_set_state, sys_pfm_set_state)

Please use always absolute numbers. That's much nicer for people
who grep for them.

-Andi

