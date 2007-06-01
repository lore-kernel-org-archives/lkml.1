Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbXFAWdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbXFAWdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXFAWdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:33:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59664 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXFAWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:33:16 -0400
Date: Fri, 1 Jun 2007 15:33:02 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-ID: <20070601223302.GY20632@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070531231354.GR20632@ca-server1.us.oracle.com> <20070601010129.GA15878@wotan.suse.de> <20070601012440.GS20632@ca-server1.us.oracle.com> <20070601013402.GB28585@wotan.suse.de> <20070601014517.GT20632@ca-server1.us.oracle.com> <20070601015349.GC28585@wotan.suse.de> <20070601052039.GU20632@ca-server1.us.oracle.com> <20070601220117.GW20632@ca-server1.us.oracle.com> <20070601152537.a04209ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601152537.a04209ff.akpm@linux-foundation.org>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 03:25:37PM -0700, Andrew Morton wrote:
> > Andrew, if this is ok with you I'd really like to see that fix in -mm. Ocfs2
> > shared write mmap will instantly deadlock without it.
> 
> ug, OK.  I get a ginormous reject when merging ocfs2 on Nick's stuff which
> I've been largely ignoring thus far.

Huh, I'm a bit confused... I created this patch on top of 2.6.22-rc3-mm1
which most certainly contains a merge of git-ocfs2.patch and the series
which at least contains
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch.

So, which of Nick's patches are we talking about here?

Btw, I know you tend to handle rejects yourself, but if it's a major PITA
I'd be happy to help out. Boy, I'm hoping I didn't just ask for a load of
trouble there :)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
