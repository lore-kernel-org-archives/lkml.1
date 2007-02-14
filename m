Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbXBNHbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbXBNHbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 02:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932175AbXBNHbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 02:31:11 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:29779 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbXBNHbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 02:31:10 -0500
X-AuditID: d80ac287-a02ebbb000007e48-5d-45d2bdb88a8c 
Date: Wed, 14 Feb 2007 07:31:13 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Randy Dunlap <randy.dunlap@oracle.com>, tony.luck@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch] build error: allnoconfig fails on mincore/swapper_space
In-Reply-To: <45D266E3.4050905@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0702140727180.4224@blonde.wat.veritas.com>
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com>
 <20070212150802.f240e94f.akpm@linux-foundation.org> <45D12715.4070408@yahoo.com.au>
 <20070213121217.0f4e9f3a.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702132224280.3729@blonde.wat.veritas.com>
 <20070213144909.70943de2.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702140009320.21315@blonde.wat.veritas.com>
 <45D266E3.4050905@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 14 Feb 2007 07:31:08.0821 (UTC) FILETIME=[18234C50:01C7500A]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Nick Piggin wrote:
> 
> Can't you have migration without swap?

Yes: but then the only swap entry it can find (short of page
table corruption, which isn't really the focus of mincore)
is a migration entry, isn't it?

Hugh
