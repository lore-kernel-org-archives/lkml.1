Return-Path: <linux-kernel-owner+w=401wt.eu-S933226AbXAYEx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbXAYEx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXAYEx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:53:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933226AbXAYExz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:53:55 -0500
Message-ID: <45B835FE.6030107@redhat.com>
Date: Wed, 24 Jan 2007 23:45:50 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
CC: Christoph Lameter <clameter@sgi.com>, Aubrey Li <aubreylee@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com> <45B75208.90208@linux.vnet.ibm.com> <Pine.LNX.4.64.0701240655400.9696@schroedinger.engr.sgi.com> <45B82F41.9040705@linux.vnet.ibm.com>
In-Reply-To: <45B82F41.9040705@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:

> In my opinion, once a
> file page is mapped by the process, then it should be treated at par
> with anon pages.  Application programs generally do not mmap a file
> page if the reuse for the content is very low.

Why not have the VM measure this, instead of making wild
assumptions about every possible workload out there?

There are a few databases out there that mmap the whole
thing.  Sleepycat for one...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
