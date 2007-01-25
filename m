Return-Path: <linux-kernel-owner+w=401wt.eu-S1030271AbXAYQOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030271AbXAYQOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030270AbXAYQOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:14:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030274AbXAYQOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:14:44 -0500
Message-ID: <45B8D5AB.8040803@redhat.com>
Date: Thu, 25 Jan 2007 11:07:07 -0500
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
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com> <45B75208.90208@linux.vnet.ibm.com> <Pine.LNX.4.64.0701240655400.9696@schroedinger.engr.sgi.com> <45B82F41.9040705@linux.vnet.ibm.com> <45B835FE.6030107@redhat.com> <45B844E3.4050203@linux.vnet.ibm.com>
In-Reply-To: <45B844E3.4050203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:
> Rik van Riel wrote:

>> There are a few databases out there that mmap the whole
>> thing.  Sleepycat for one...
> 
> That is why my suggestion would be not to touch mmapped pagecache
> pages in the current pagecache limit code.  The limit should concern
> only unmapped pagecache pages.

So you want to limit how much data the kernel caches for mysql
or postgresql, but not limit how much of the rpm database is
cached ?!

IMHO your proposal does the exact opposite of what would be
right for my systems :)

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
