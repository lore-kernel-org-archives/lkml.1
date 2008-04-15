Return-Path: <linux-kernel-owner+w=401wt.eu-S1764821AbYDOVTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764821AbYDOVTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYDOVT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:19:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:35540 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbYDOVT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=In6mFKTxKZCfu/Xl/WhDYobzIBK2ckFmkc9VH7LsyzkI5DtAJqrjId0Dw5H7y3eg0ACH+1rbP+VYcxGEHJ498vJvJv/Im/W877Fk3iJ6YUAUReenu6vSbi6ENh1deRVzhAeu9UZYrTuBIX3VfBkhhYZSP7P0bsDXzapu5adlY8o=
Message-ID: <86802c440804151419i42f6a4caj3bb23b6c21d9238d@mail.gmail.com>
Date: Tue, 15 Apr 2008 14:19:20 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>, suresh.b.siddha@intel.com
Subject: Re: + bootmem-node-setup-agnostic-free_bootmem.patch added to -mm tree
Cc: "Ingo Molnar" <mingo@elte.hu>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, ak@suse.de, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <87ej96hlc1.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
	 <20080415071120.GB15499@elte.hu> <87hce3i8mq.fsf@saeurebad.de>
	 <86802c440804151157m5baab2efla7f35a8f98ac76b7@mail.gmail.com>
	 <87mynuhp0o.fsf@saeurebad.de>
	 <86802c440804151303k29295e9bp70c1046b8c9dca76@mail.gmail.com>
	 <87ej96hlc1.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 2:14 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi,
>
>  "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>
> >>  > 2. intel cross node box: node0: 0g-2g, 4g-6g, node1: 2g-4g, 6g-8g. i
>  >>  > don't think they have two bdata struct for every node.
>  >>
>  >>  How do the bdata structures represent this setup right now?  Are you
>  >>  sure that there is not a node descriptor for every contiguous region?
>  >
>  > http://lkml.org/lkml/2008/3/25/233
>  >
>  > Subject       [patch] srat, x86_64: Add support for nodes spanning other nodes
>  >
>  > For example, If the physical address layout on a two node system with 8 GB
>  > memory is something like:
>  > node 0: 0-2GB, 4-6GB
>  > node 1: 2-4GB, 6-8GB
>  >
>  > Current kernels fail to boot/detect this NUMA topology.
>  >
>  > ACPI SRAT tables can expose such a topology which needs to be supported.
>  >
>  > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
>  As I understood the code (more guessing than understanding), it breaks
>  down these physical nodes into contiguous logical memory blocks which
>  then get represented by having a node descriptor for each of them.  Can
>  you confirm that?

Not sure, on x86_64 one node should have one bdata only.
execpt suresh update that to make one node have two bdata.

YH
