Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbXDJV6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbXDJV6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXDJV6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:58:31 -0400
Received: from mail.suse.de ([195.135.220.2]:45855 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbXDJV6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:58:30 -0400
To: Jan Kara <jack@suse.cz>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH] Improve heuristic detecting sequential reads
References: <20070410155411.GF13445@duck.suse.cz>
From: Andi Kleen <andi@firstfloor.org>
Date: 11 Apr 2007 00:56:51 +0200
In-Reply-To: <20070410155411.GF13445@duck.suse.cz>
Message-ID: <p73y7kzj0ss.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hello!
> 
>   In thread http://lkml.org/lkml/2007/3/9/403, we discussed a problem
> with the current heuristic for detecting sequential IO in
> do_generic_mapping_read() - for small files a page is marked as accessed
> only once which can cause a performance problems.
>   Attached is a patch that improves the heuristic by introducing a
> ra.offset variable so now we can reliably detect sequetial reads.
> The patch replaces Nick's patch from http://lkml.org/lkml/2007/3/15/177
> (Nick has acked to replace the patch). Could you please put the patch
> into -mm?

There's a much more complete patchkit for this that gets reposted
regularly on l-k. Perhaps it would make sense to test that first?

-Andi
