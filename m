Return-Path: <linux-kernel-owner+w=401wt.eu-S1765680AbXF1Szh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765680AbXF1Szh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbXF1Sz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:55:29 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:47182 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104AbXF1Sz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:55:29 -0400
Date: Thu, 28 Jun 2007 14:55:26 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] ICH Force HPET: Make generic time capable of switching
 broadcast timer
In-Reply-To: <20070628110254.3957c927.akpm@linux-foundation.org>
Message-ID: <Line.LNX.4.64.0706281452400.14008@localhost.localdomain>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
 <20070628001221.364438ce.akpm@linux-foundation.org>
 <20070628012749.caf450f6.akpm@linux-foundation.org>
 <1183034748.3504.3.camel@localhost.localdomain> <20070628110254.3957c927.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Andrew Morton wrote:

> We cannot merge a kernel change which requires a userspace upgrade to get
> the X server working again.

Agreed.

> 
> You can do it the other way: make the X server work by default (my patch)
> then, in your upgraded userspace, set /proc/sys/kernel/mmap_min_addr to
> 65536.  
> 
> Repeat: I think you should have used /proc/sys/vm/ for that tunable.

Andrew, I sent patches for these earlier.  Possibly lost somewhere?

http://marc.info/?l=linux-kernel&m=118304565827673&w=2
http://marc.info/?l=linux-kernel&m=118304566015586&w=2


-- 
James Morris
<jmorris@namei.org>
