Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYLESaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYLESaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYLESaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:30:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53028 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYLESaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:30:04 -0500
Date: Fri, 5 Dec 2008 19:41:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple barriers.)
Message-ID: <20081205184114.GE6703@one.firstfloor.org>
References: <bFquY-2x2-5@gated-at.bofh.it> <bFsnc-51o-37@gated-at.bofh.it> <bFuyC-7Zt-11@gated-at.bofh.it> <bFvuI-L8-29@gated-at.bofh.it> <bFwTJ-2oc-13@gated-at.bofh.it> <bFxwq-3g7-1@gated-at.bofh.it> <bFxGa-3pz-1@gated-at.bofh.it> <bFHvW-7up-5@gated-at.bofh.it> <bFHPd-84I-13@gated-at.bofh.it> <E1L8fIY-0001ui-DV@be1.7eggert.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1L8fIY-0001ui-DV@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 07:21:06PM +0100, Bodo Eggert wrote:
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> >> Not when the fundamental design of the code is broken and trashes
> >> performance.
> > 
> > Sorry but that's just not correct. There's nothing in late failing
> > barriers that "trashes performance". The file system writers have 
> > to be careful to handle it, but at least the current ones all do.
> 
> So let's keep requiring the "trashes performance" hacks, because they're

Again there's nothing about the code that handles this that 
"trashes performance". 

Mickulas was just ranting that the current file systems don't use
barriers in the way he thinks they ought to be used, but that
is completely orthogonal to the problem if barriers may fail
late or not.

In Mickulas imaginary barrier world it would be slightly more 
complicated to handle it, but far from impossible. And again
if there it wouldn't affect performance. In the real world
Linux barrier world handling late failing barriers in the fs
is also very easy currently.

-Andi

