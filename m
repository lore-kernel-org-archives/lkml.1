Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbZIDHFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbZIDHFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933201AbZIDHFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:05:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933226AbZIDHFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:05:33 -0400
Date: Fri, 4 Sep 2009 09:05:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 29/33] Remove the global inode_hash_lock and replace it with per-hash-bucket locks. fs: inode per-bucket inode hash locks
Message-ID: <20090904070535.GB1875@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net> <20090904065538.536556189@nick.local0.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904065538.536556189@nick.local0.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And sorry about the messed up subject on this one.

On Fri, Sep 04, 2009 at 04:52:10PM +1000, npiggin@suse.de wrote:
> Todo: should use bit spinlock in hlist_head pointer to save space.
