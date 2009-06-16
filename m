Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZFPK0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZFPK0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZFPK0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:26:43 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:46248 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZFPK0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:26:43 -0400
Date: Tue, 16 Jun 2009 11:20:34 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, wli@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Enable hugetlbfs for more systems.
Message-ID: <20090616102034.GC13622@linux-mips.org>
References: <4A1DDED7.3020306@caviumnetworks.com> <1243471666-27915-4-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243471666-27915-4-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 05:47:45PM -0700, David Daney wrote:
> From: David Daney <ddaney@caviumnetworks.com>
> Date: Wed, 27 May 2009 17:47:45 -0700
> To: linux-mips@linux-mips.org, ralf@linux-mips.org
> Cc: wli@holomorphy.com, David Daney <ddaney@caviumnetworks.com>

Holomorphy.com is unreachable since like a year.  Use wli@kernel.org.

> Subject: [PATCH 4/5] Enable hugetlbfs for more systems.
> 
> As part of adding hugetlbfs support for MIPS, I am adding a new
> kconfig variable 'SYS_SUPPORTS_HUGETLBFS'.  Since some mips cpu
> varients don't yet support it, we can enable selection of HUGETLBFS on
> a system by system basis from the arch/mips/Kconfig.
> 
> CC: William Irwin <wli@holomorphy.com>
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> ---
>  fs/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 9f7270f..c36d63b 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -124,7 +124,7 @@ config TMPFS_POSIX_ACL
>  config HUGETLBFS
>  	bool "HugeTLB file system support"
>  	depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || \
> -		   (S390 && 64BIT) || BROKEN
> +		   (S390 && 64BIT) || SYS_SUPPORTS_HUGETLBFS || BROKEN

I'm ok with this patch but it's really crying for some follup patch to
convert all the other architectures to use SYS_SUPPORTS_HUGETLBFS.

  Ralf
