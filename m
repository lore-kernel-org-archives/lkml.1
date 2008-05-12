Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbYELUno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbYELUno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759363AbYELUn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:43:26 -0400
Received: from outbound-mail-108.bluehost.com ([69.89.22.8]:36610 "HELO
	outbound-mail-108.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759333AbYELUnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:43:24 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: mgross@linux.intel.com
Subject: Re: [PATCH]Make the intel-iommu_wait_op macro work when jiffies are not running
Date: Mon, 12 May 2008 13:43:22 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
References: <20080512204157.GA32017@linux.intel.com>
In-Reply-To: <20080512204157.GA32017@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805121343.22735.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 12, 2008 1:41 pm mark gross wrote:
> The following patch changes the intel-iommu.c code to use the TSC
> instead of jiffies for detecting bad DMAR functionality.  Some systems
> with bad bios's have been seen to hang in early boot spinning in the
> IOMMU_WAIT_IO macro.  This patch will replace the forever spin with a
> call to panic.
>
>
> diffstat:
> $ diffstat patches/wait_op_tsc.patch
>  intel-iommu.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --mgross
>
> Signed-off-by:mark gross <mgross@linux.intel.com>

Applied to the 'for-linus' tree.

Thanks,
Jesse
