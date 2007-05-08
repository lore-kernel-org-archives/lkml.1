Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbXEHQHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbXEHQHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968111AbXEHQHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:07:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47695 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934833AbXEHQHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:07:04 -0400
Date: Tue, 8 May 2007 09:07:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
In-Reply-To: <46407554.10801@shadowen.org>
Message-ID: <Pine.LNX.4.64.0705080906290.8722@schroedinger.engr.sgi.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
 <46407554.10801@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Andy Whitcroft wrote:

> The SLUB code introduces the config segment below to stop SLUB being
> used on powerpc:
> 
>     config ARCH_USES_SLAB_PAGE_STRUCT
>        bool
>        default y
>        depends on SPLIT_PTLOCK_CPUS <= NR_CPUS
> 
> However as far as I can kconfig has no support for operators other than
> ==, !=, &&, and ||.  Who can say why we do not get an error.
> 
> Cirtainly in my testing this simply never triggers and bad kernels result.
> 
> Thoughts?

Get rid of the whole patch as soon as possible? It seems that PPC work is 
in progress to make SLUB work in all configurations.

