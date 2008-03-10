Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbYCJWRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbYCJWRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYCJWQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:16:55 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:44147 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYCJWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:16:54 -0400
Date: Mon, 10 Mar 2008 22:15:38 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/5] shmem: use call_once()
In-Reply-To: <20080310150308.GC6407@APFDCB5C>
Message-ID: <Pine.LNX.4.64.0803102211240.6396@blonde.site>
References: <20080310145704.GA6396@APFDCB5C> <20080310150026.GA6407@APFDCB5C>
 <20080310150148.GB6407@APFDCB5C> <20080310150308.GC6407@APFDCB5C>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Akinobu Mita wrote:
> This patch defers mounting tmpfs till shmem_file_setup() is
> called first time by using call_once().

Please explain why we might need this patch: is something changing
elsewhere?  Or are you misled by that "module_init(init_tmpfs)"
into thinking that mm/shmem.c is sometimes built modular?

Hugh
