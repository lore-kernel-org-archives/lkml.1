Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbXJXWxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbXJXWxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbXJXWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:53:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53533 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755532AbXJXWxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:53:08 -0400
Date: Wed, 24 Oct 2007 15:48:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: ak@suse.de, jeremy@goop.org, ying.huang@intel.com, ebiederm@xmission.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v7 1/3] x86 boot: setup data
Message-Id: <20071024154800.4e0735eb.akpm@linux-foundation.org>
In-Reply-To: <471E89E1.7060903@zytor.com>
References: <1193126771.23935.79.camel@caritas-dev.intel.com>
	<471E70E0.2090802@goop.org>
	<200710240118.21160.ak@suse.de>
	<471E89E1.7060903@zytor.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 16:55:13 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Andi Kleen wrote:
> > 
> > With the early reserve code in 
> > ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve
> > and
> > ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-alloc
> > this could be likely done cleaner.
> > 
> 
> Indeed it could.  For i386, the equivalent code would have another 
> significant benefit: reserving memory and then mapping and accessing it 
> later would (at least eventually) allow accesses > 4 GB on PAE kernels 
> (or with a PSE36 hack, on non-PAE kernels.)
> 

Cleaner sounds good.  I'll duck these patches for now.

This one doesn't apply, btw: setup_32.h disappeared.
