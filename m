Return-Path: <linux-kernel-owner+w=401wt.eu-S2993043AbXEBLYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993043AbXEBLYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993048AbXEBLYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:24:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:44144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993043AbXEBLYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:24:03 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Cabot, Mason B" <mason.b.cabot@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: Ext3 vs NTFS performance
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
	<20070501142325.09c294bd.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 May 2007 14:21:40 +0200
In-Reply-To: <20070501142325.09c294bd.akpm@linux-foundation.org>
Message-ID: <p73slafxvor.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> Conceivably we could address this in the filesystem without mucking other
> things up.  But I'd have thought the simplest damage-control would be to
> detect this pattern in samba and to then use glibc's fallocate().

The advantage of detecting it in kernel would be that it would handle
Linux applications that do this (I suspect there are some) too.

-Andi
