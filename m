Return-Path: <linux-kernel-owner+w=401wt.eu-S1422718AbXCOPCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422718AbXCOPCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 11:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422862AbXCOPCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 11:02:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422718AbXCOPCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 11:02:11 -0400
Message-ID: <45F95FA8.6060207@redhat.com>
Date: Thu, 15 Mar 2007 11:00:56 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
CC: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ashif Harji <asharji@cs.uwaterloo.ca>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] mm/filemap.c: unconditionally call mark_page_accessed
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca> <20070312142012.GH30777@atrey.karlin.mff.cuni.cz> <20070312143900.GB6016@wotan.suse.de> <20070312151355.GB23532@duck.suse.cz> <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca> <20070312173500.GF23532@duck.suse.cz> <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca> <20070313185554.GA5105@duck.suse.cz> <Pine.GSO.4.64.0703141218530.28958@cpu102.cs.uwaterloo.ca> <1173905741.8763.36.camel@kleikamp.austin.ibm.com> <20070314213317.GA22234@rhlx01.hs-esslingen.de>
In-Reply-To: <20070314213317.GA22234@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:

> I've been thinking hard how to avoid the mark_page_accessed() starvation in
> case of a fixed, (almost) non-changing access state, but this seems hard since
> it'd seem we need some kind of state management here to figure out good
> intervals of when to call mark_page_accessed() *again* for this page. 

Like this? :)

http://surriel.com/patches/clockpro/2.6.12/useonce-cleanup

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
