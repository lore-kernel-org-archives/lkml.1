Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbXIGH3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbXIGH3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 03:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbXIGH3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 03:29:13 -0400
Received: from mail.suse.de ([195.135.220.2]:39886 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089AbXIGH3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 03:29:12 -0400
From: Andi Kleen <ak@suse.de>
To: travis@sgi.com
Subject: Re: [PATCH 0/3] core: fix build error when referencing arch specific structures
Date: Fri, 7 Sep 2007 08:28:05 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20070907040943.467530005@sgi.com>
In-Reply-To: <20070907040943.467530005@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709070828.05730.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2007 05:09, travis@sgi.com wrote:
> Since the core kernel routines need to reference cpu_sibling_map,
> whether it be a static array or a per_cpu data variable, an access
> function has been defined.
>
> In addition, changes have been made to the ia64 and ppc64 arch's to
> move the cpu_sibling_map from a static cpumask_t array [NR_CPUS] to
> be per_cpu cpumask_t arrays.
>
> Note that I do not have the ability to build or test patch 3/3, the
> ppc64 changes.
>
> Patches are referenced against 2.6.23-rc4-mm1 .

It would be better if you could redo the patches with the original patches
reverted, not incremental changes. In the end we'll need a full patch set
with full changelog anyways, not a series of incremental fixes.

Also I guess some powerpc testers would be needed. Perhaps cc the
maintainers?

-Andi
