Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZKMSBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZKMSBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZKMSBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:01:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45408 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbZKMSBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:01:19 -0500
Date: Sat, 14 Nov 2009 03:00:59 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 2/6] mm: mlocking in try_to_unmap_one
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20091113115026.GU21482@random.random>
References: <20091113172453.33CB.A69D9226@jp.fujitsu.com> <20091113115026.GU21482@random.random>
Message-Id: <20091114025202.3DAB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Nov 13, 2009 at 05:26:14PM +0900, KOSAKI Motohiro wrote:
> > Probably we can remove VM_NONLINEAR perfectly. I've never seen real user of it.
> 
> Do you mean as a whole or in the mlock logic? databases are using
> remap_file_pages on 32bit archs to avoid generating zillon of vmas on
> tmpfs scattered mappings. On 64bits it could only be useful to some
> emulators but with real shadow paging and nonlinear rmap already
> created on shadow pagetables, it looks pretty useless on 64bit archs
> to me.

Hehe, you point out kosaki is stupid and knoledgeless.
thanks correct me.

Probaby we have to maintain VM_NONLINEAR for one or two year. two years
later, nobody use database on 32bit machine.
(low-end DB might be use on 32bit, but that's ok. it doesn't use VM_NONLINEAR)




