Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZDGGMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZDGGMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZDGGM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:12:27 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55700 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbZDGGM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:12:26 -0400
Date: Tue, 7 Apr 2009 07:10:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Paul Mackerras <paulus@samba.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Yuri Tikhonov <yur@emcraft.com>,
       yanok@emcraft.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, prodyuth@gmail.com
Subject: Re: [PATCH 3/3] powerpc: allow 256kB pages with SHMEM
In-Reply-To: <18906.51307.281300.189948@drongo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0904070704110.28004@blonde.anvils>
References: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
 <Pine.LNX.4.64.0904062156290.21044@blonde.anvils>
 <18906.51307.281300.189948@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Paul Mackerras wrote:
> Hugh Dickins writes:
> 
> > Now that shmem's divisions by zero and SHMEM_MAX_BYTES are fixed,
> > let powerpc 256kB pages coexist with CONFIG_SHMEM again.
> > 
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > ---
> > Added linuxppc-dev and some other Cc's for this 3/3: sorry
> > if you didn't see 1/3 and 2/3, they were just in mm/shmem.c.
> 
> Looks OK - what path are you using to get the series upstream?
> (I.e. should I be putting 3/3 in the powerpc tree or are you going to
> push it along with the others?)

If it's OK with you (and you're saying it is), I think the best
would be for it to sit alongside 1/3 and 2/3 in Andrew's tree,
hopefully get an Ack from Yuri (I don't have any powerpc 256kB
pages myself to test it fully), and then go on into 2.6.30.

Hugh
