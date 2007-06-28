Return-Path: <linux-kernel-owner+w=401wt.eu-S1765197AbXF1TMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765197AbXF1TMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 15:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbXF1TMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 15:12:07 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:59375 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbXF1TMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 15:12:06 -0400
Date: Thu, 28 Jun 2007 15:12:00 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] security: move mmap_min_addr sysctl to /proc/sys/vm
In-Reply-To: <20070628190503.GA5803@martell.zuzino.mipt.ru>
Message-ID: <Line.LNX.4.64.0706281511340.14150@localhost.localdomain>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
 <20070628001221.364438ce.akpm@linux-foundation.org>
 <20070628012749.caf450f6.akpm@linux-foundation.org>
 <Line.LNX.4.64.0706281139010.13114@localhost.localdomain>
 <Line.LNX.4.64.0706281140530.13114@localhost.localdomain>
 <20070628190503.GA5803@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Alexey Dobriyan wrote:

> On Thu, Jun 28, 2007 at 11:41:38AM -0400, James Morris wrote:
> > Move mmap_min_addr sysctl to /proc/sys/vm, as suggested by Andrew Morton.
> 
> Probably too late, since it's userspace visible. Everyone using
> /proc/sys/kernel/mmap_min_addr in scrips will be surprised.

It's only in -mm so far.


-- 
James Morris
<jmorris@namei.org>
