Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbXFZUtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbXFZUtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbXFZUtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:49:01 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47127 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757954AbXFZUtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:49:00 -0400
Subject: Re: [-mm patch] remove nobh_{prepare,commit}_write()
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070626133203.d1aa5383.akpm@linux-foundation.org>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	 <20070614221555.GY3588@stusta.de>
	 <20070626133203.d1aa5383.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 15:48:58 -0500
Message-Id: <1182890938.11569.27.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 13:32 -0700, Andrew Morton wrote:
> On Fri, 15 Jun 2007 00:15:55 +0200
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > nobh_{prepare,commit}_write() are no longer used.
> 
> wth?  What happened to ext2 and ext3 nobh mode?  They seem to
> have magically and unchangeloggedly disappeared?

They were removed with Nick's new aops patches.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

