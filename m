Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYAWQVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYAWQVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYAWQVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:21:08 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:36942 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752654AbYAWQVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:21:07 -0500
Date: Thu, 24 Jan 2008 01:21:03 +0900 (JST)
Message-Id: <20080124.012103.105433865.taka@valinux.co.jp>
To: agk@redhat.com
Cc: ryov@valinux.co.jp, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [dm-devel] [PATCH 0/2] dm-band: The I/O bandwidth controller:
 Overview
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080123144717.GS8075@agk.fab.redhat.com>
References: <20080123.215350.193721890.ryov@valinux.co.jp>
	<20080123144717.GS8075@agk.fab.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Wed, Jan 23, 2008 at 09:53:50PM +0900, Ryo Tsuruta wrote:
> > Dm-band gives bandwidth to each job according to its weight, 
> > which each job can set its own value to.
> > At this time, a job is a group of processes with the same pid or pgrp or uid.
> 
> It seems to rely on 'current' to classify bios and doesn't do it until the map
> function is called, possibly in a different process context, so it won't
> always identify the original source of the I/O correctly:

Yes, this should be mentioned in the document with the current implementation
as you pointed out.

By the way, I think once a memory controller of cgroup is introduced, it will
help to track down which cgroup is the original source.

> people need to take
> this into account when designing their group configuration and so this should
> be mentioned in the documentation.
>
> I've uploaded it here while we consider ways we might refine the architecture and
> interfaces etc.:
> 
>   http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-add-band-target.patch
> 
> Alasdair
> -- 
> agk@redhat.com

Thank you,
Hirokazu Takahashi.
