Return-Path: <linux-kernel-owner+w=401wt.eu-S933198AbXAYEXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbXAYEXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXAYEXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:23:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbXAYEXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:23:12 -0500
Message-ID: <45B82FAB.9040205@redhat.com>
Date: Wed, 24 Jan 2007 23:18:51 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Aubrey Li <aubreylee@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> This is a patch using some of Aubrey's work plugging it in what is IMHO 
> the right way. Feel free to improve on it. I have gotten repeatedly 
> requests to be able to limit the pagecache. 

IMHO it's a bad hack.

It would be better to identify the problem this "feature" is
trying to fix, and then fix the root cause.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
