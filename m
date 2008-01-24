Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYAXDiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYAXDiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 22:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYAXDiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 22:38:09 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:36518 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751392AbYAXDiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 22:38:08 -0500
To: taka@valinux.co.jp
Cc: agk@redhat.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 0/2] dm-band: The I/O bandwidth controller:
 Overview
In-Reply-To: Your message of "Thu, 24 Jan 2008 01:21:03 +0900 (JST)"
	<20080124.012103.105433865.taka@valinux.co.jp>
References: <20080124.012103.105433865.taka@valinux.co.jp>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080124033807.42D7B1E3C0C@siro.lan>
Date: Thu, 24 Jan 2008 12:38:07 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> > On Wed, Jan 23, 2008 at 09:53:50PM +0900, Ryo Tsuruta wrote:
> > > Dm-band gives bandwidth to each job according to its weight, 
> > > which each job can set its own value to.
> > > At this time, a job is a group of processes with the same pid or pgrp or uid.
> > 
> > It seems to rely on 'current' to classify bios and doesn't do it until the map
> > function is called, possibly in a different process context, so it won't
> > always identify the original source of the I/O correctly:
> 
> Yes, this should be mentioned in the document with the current implementation
> as you pointed out.
> 
> By the way, I think once a memory controller of cgroup is introduced, it will
> help to track down which cgroup is the original source.

do you mean to make this a part of the memory subsystem?

YAMAMOTO Takashi
