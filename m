Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYAXKPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYAXKPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 05:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYAXKPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 05:15:01 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:55375 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752397AbYAXKPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 05:15:00 -0500
Date: Thu, 24 Jan 2008 19:14:56 +0900 (JST)
Message-Id: <20080124.191456.119427875.taka@valinux.co.jp>
To: yamamoto@valinux.co.jp
Cc: agk@redhat.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 0/2] dm-band: The I/O bandwidth controller:
 Overview
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080124033807.42D7B1E3C0C@siro.lan>
References: <20080124.012103.105433865.taka@valinux.co.jp>
	<20080124033807.42D7B1E3C0C@siro.lan>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > On Wed, Jan 23, 2008 at 09:53:50PM +0900, Ryo Tsuruta wrote:
> > > > Dm-band gives bandwidth to each job according to its weight, 
> > > > which each job can set its own value to.
> > > > At this time, a job is a group of processes with the same pid or pgrp or uid.
> > > 
> > > It seems to rely on 'current' to classify bios and doesn't do it until the map
> > > function is called, possibly in a different process context, so it won't
> > > always identify the original source of the I/O correctly:
> > 
> > Yes, this should be mentioned in the document with the current implementation
> > as you pointed out.
> > 
> > By the way, I think once a memory controller of cgroup is introduced, it will
> > help to track down which cgroup is the original source.
> 
> do you mean to make this a part of the memory subsystem?

I just think if the memory subsystem is in front of us, we don't need to
reinvent the wheel.

But I don't have a concrete image how the interface between dm-band and
the memory subsystem should be designed yet. I'd be appreciate if some of
the cgroup developers give some ideas about it.

Thanks,
Hirokazu Takahashi.


> YAMAMOTO Takashi

