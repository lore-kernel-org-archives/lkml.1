Return-Path: <linux-kernel-owner+w=401wt.eu-S1767002AbXEBUjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767002AbXEBUjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767009AbXEBUjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:39:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33597 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767002AbXEBUjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:39:13 -0400
Message-ID: <4638F6DF.7020400@garzik.org>
Date: Wed, 02 May 2007 16:38:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Jeremy Allison <jra@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Cabot, Mason B" <mason.b.cabot@intel.com>,
       linux-kernel@vger.kernel.org, tridge@samba.com
Subject: Re: Ext3 vs NTFS performance
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070501142325.09c294bd.akpm@linux-foundation.org> <20070502161638.GB19442@thunk.org> <20070502180810.GC28726@jeremy-laptop> <20070502193456.GE19442@thunk.org>
In-Reply-To: <20070502193456.GE19442@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> 	FYI, we are currently closing on a new system call so that
> glibc's fallocate() will be able to call into the appropriate
> per-filesystem routines in a portable way, since ext4 will have
> persistent preallocation support.

Yep.


> 	I think we mostly have consensus on a calling convention which
> all of the architectures (s390, power, arm, ia64, etc.); of course
> then we will need to get glibc to support the new system call.

glibc has had support for a while, in emulated form: 
http://www.uwsg.iu.edu/hypermail/linux/kernel/0004.1/1153.html

So when kernel support arrives, it should be easy and (hopefully) 
seamless to plug in the new syscall.

	Jeff


