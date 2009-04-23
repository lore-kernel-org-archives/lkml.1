Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZDWWkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZDWWkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZDWWkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:40:05 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:32902 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbZDWWkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:40:03 -0400
Date: Thu, 23 Apr 2009 18:31:34 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: add
 Documentation/ABI/testing/sysfs-kernel-slab
In-Reply-To: <alpine.DEB.2.00.0904231510020.30545@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0904231829550.26300@qirst.com>
References: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com> <alpine.DEB.2.00.0904231137440.20852@chino.kir.corp.google.com> <alpine.DEB.2.00.0904231510020.30545@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, David Rientjes wrote:

>  - slqb uses /sys/kernel/slab as well and we simply add its files in
>    sysfs-kernel-slab and leave it to userspace to test for which allocator
>    is actually being used.  Both allocators share many of the same
>    fundamental attributes but some are only applicable to one,
>
>  - slqb moves to /sys/kernel/slqb since slub is already resident in
>    /sys/kernel/slab and the mm/slab.c allocator actually has no sysfs
>    interface, or

slqb cannot be concurrently used with slub. So slqb can use
/sys/kernel/slab as well. So could the original slab allocator.
Dont change this.

