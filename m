Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbYEFEVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbYEFEVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYEFEVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:21:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbYEFEVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:21:03 -0400
Date: Mon, 5 May 2008 21:20:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net, sam@ravnborg.org
Subject: Re: [RFC PATCH 2/6] kbuild: let addtree result in absolute paths
 only
Message-Id: <20080505212019.f4540931.akpm@linux-foundation.org>
In-Reply-To: <481F26A0.5010402@de.ibm.com>
References: <481F26A0.5010402@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 17:24:16 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> ---
>  scripts/Kbuild.include |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.26-rc1/scripts/Kbuild.include
> ===================================================================
> --- linux-2.6.26-rc1.orig/scripts/Kbuild.include
> +++ linux-2.6.26-rc1/scripts/Kbuild.include
> @@ -144,7 +144,7 @@ ld-option = $(call try-run,\
>  build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
>  
>  # Prefix -I with $(srctree) if it is not an absolute path.
> -addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
> +addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1))
>  
>  # Find all -I options and call addtree
>  flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
> 

-ENOCHANGLEOG.  What is the reason for this change?
