Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbXKUKTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbXKUKTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbXKUKSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:18:54 -0500
Received: from mail.suse.de ([195.135.220.2]:40929 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbXKUKSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:18:53 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: travis@sgi.com
Subject: Re: [PATCH 0/2] x86: Reduce pressure on stack from cpumask usage -v2
Date: Wed, 21 Nov 2007 11:18:44 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, mingo@elte.hu, apw@shadowen.org,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20071121100201.156191000@sgi.com>
In-Reply-To: <20071121100201.156191000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711211118.45137.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007 11:02:01 travis@sgi.com wrote:
> 
> v2:
>     - fix some compile errors when NR_CPUS > default for ia386 (128 & 4096)
>     - remove unneccessary includes
> 
> Convert cpumask_of_cpu to use a static percpu data array and
> set_cpus_allowed to pass the cpumask_t arg as a pointer.

I'm not sure that is too useful alone because you didn't solve the
set_cpus_allowed(oldmask) problem.

-Andi
