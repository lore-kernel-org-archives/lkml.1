Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbZGUW3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbZGUW3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbZGUW3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:29:02 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:50615 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755898AbZGUW3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:29:01 -0400
Date: Tue, 21 Jul 2009 17:47:09 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, rusty@rustcorp.com.au,
       hpa@zytor.com, tglx@linutronix.de, akpm@linux-foundation.org,
       x86@kernel.org, andi@firstfloor.org
Subject: Re: [PATCH 03/20] percpu: rename 4k first chunk allocator to page
In-Reply-To: <1248171979-29166-4-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.1.10.0907211745080.25867@gentwo.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org> <1248171979-29166-4-git-send-email-tj@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Jul 2009, Tejun Heo wrote:

> - * Boring fallback 4k allocator.  This allocator puts more pressure on
> - * PTE TLBs but other than that behaves nicely on both UMA and NUMA.
> + * Boring fallback 4k page allocator.  This allocator puts more

Guess this should not mentione 4k anymroe? page size allocation?

>  				pr_warning("PERCPU: %s allocator failed (%zd), "
> -					   "falling back to 4k\n",
> +					   "falling back to page\n",

"falling back to page size"?

