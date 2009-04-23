Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbZDWXEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbZDWXEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbZDWXDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:03:55 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:41722 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbZDWXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:03:54 -0400
Date: Thu, 23 Apr 2009 18:55:31 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: add
 Documentation/ABI/testing/sysfs-kernel-slab
In-Reply-To: <alpine.DEB.2.00.0904231549130.32736@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0904231854130.26300@qirst.com>
References: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com> <alpine.DEB.2.00.0904231137440.20852@chino.kir.corp.google.com> <alpine.DEB.2.00.0904231510020.30545@chino.kir.corp.google.com> <alpine.DEB.1.10.0904231829550.26300@qirst.com>
 <alpine.DEB.2.00.0904231549130.32736@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, David Rientjes wrote:

> I'm more concerned with the userspace API.  You're comfortable with
> letting userspace determine what allocator the kernel is using either by
> testing for the presence of certain slub or slqb-specific files or
> checking the config?

Why would userspace have to test? If the fields have the same semantics
then we are fine.

> That should be fine since there's parity among the files that both
> allocators share, but seems fragile if an allocator adds a file that was
> previously only applicable to the other or the API happens to change.

Right. The newly added file must not be in use by another allocator.

> My thinking was that /sys/kernel/slqb would be a permanent reference point
> that userspace could easily test to determine what API is available.

The API is hopefully generic enought to accomodate all allocators.

