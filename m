Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZDGD27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZDGD27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZDGD2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:28:51 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:52452 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbZDGD2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:28:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18906.51307.281300.189948@drongo.ozlabs.ibm.com>
Date: Tue, 7 Apr 2009 13:28:43 +1000
From: Paul Mackerras <paulus@samba.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, yanok@emcraft.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       prodyuth@gmail.com
Subject: Re: [PATCH 3/3] powerpc: allow 256kB pages with SHMEM
In-Reply-To: <Pine.LNX.4.64.0904062156290.21044@blonde.anvils>
References: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
	<Pine.LNX.4.64.0904062156290.21044@blonde.anvils>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins writes:

> Now that shmem's divisions by zero and SHMEM_MAX_BYTES are fixed,
> let powerpc 256kB pages coexist with CONFIG_SHMEM again.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Added linuxppc-dev and some other Cc's for this 3/3: sorry
> if you didn't see 1/3 and 2/3, they were just in mm/shmem.c.

Looks OK - what path are you using to get the series upstream?
(I.e. should I be putting 3/3 in the powerpc tree or are you going to
push it along with the others?)

Paul.
