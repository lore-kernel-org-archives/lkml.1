Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbXENQNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbXENQNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbXENQNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:13:33 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:58698 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbXENQNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:13:32 -0400
Date: Mon, 14 May 2007 17:13:11 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 14/14] tmpfs whiteout support
In-Reply-To: <20070514094519.GP4139@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0705141710280.29949@blonde.wat.veritas.com>
References: <20070514093722.GB4139@in.ibm.com> <20070514094519.GP4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 14 May 2007 16:13:31.0699 (UTC) FILETIME=[D0B6B030:01C79642]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAbGludXgtZnNkZXZlbEB2Z2VyLmtlcm5lbC5vcmcAai5ibHVuY2tAdHUtaGFyYnVyZy5kZQBiaGFyYXRhQGxpbnV4LnZuZXQuaWJtLmNvbQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Bharata B Rao wrote:
> From: Jan Blunck <j.blunck@tu-harburg.de>
> Subject: tmpfs whiteout support
> 
> Introduce whiteout support to tmpfs.
> 
> Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  mm/shmem.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletion(-)
> 
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -74,7 +74,7 @@
>  #define LATENCY_LIMIT	 64
>  
>  /* Pretend that each entry is of this size in directory's i_size */
> -#define BOGO_DIRENT_SIZE 20
> +#define BOGO_DIRENT_SIZE 1

Why would that change be needed for whiteout support?

Hugh
