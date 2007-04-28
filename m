Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXD1Opy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXD1Opy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXD1Opy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:45:54 -0400
Received: from holomorphy.com ([66.93.40.71]:43089 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409AbXD1Opx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:45:53 -0400
Date: Sat, 28 Apr 2007 07:46:26 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlbfs: fix error path in module_init
Message-ID: <20070428144626.GW19966@holomorphy.com>
References: <20070428071923.GB9545@APFDCB5C> <b6fcc0a0704280044i3ff820b6w343bd73c7a08f708@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0704280044i3ff820b6w343bd73c7a08f708@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 11:44:43AM +0400, Alexey Dobriyan wrote:
> On 4/28/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >init_hugetlbfs_fs() needs to unregister hugetlbfs
> >when kern_mount() returns error.
> HUGETLBFS is bool, so __init function should panic more and
> __exit function should be removed. Or someone is planning
> making it tristate?

It'd be nice for it to be normal enough to go tristate, but there isn't
going to be any effort expended directly to that end. Might as well
remove the exit function. Probably mostly pointless to try to avoid
panicking, but I'd not bother with new panics as a simplification just
because panicking is somewhat rude.


- wli
