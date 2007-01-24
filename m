Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbXAXUOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbXAXUOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbXAXUOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:14:32 -0500
Received: from codepoet.org ([166.70.99.138]:56012 "EHLO codepoet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240AbXAXUOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:14:31 -0500
Date: Wed, 24 Jan 2007 13:06:14 -0700
From: Erik Andersen <andersen@codepoet.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Aubrey Li <aubreylee@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
Message-ID: <20070124200614.GA25690@codepoet.org>
Reply-To: andersen@codepoet.org
Mail-Followup-To: andersen@codepoet.org,
	Christoph Lameter <clameter@sgi.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Aubrey Li <aubreylee@gmail.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	"Henn, erich, Michael" <Michael.Hennerich@analog.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com> <1169625333.4493.16.camel@taijtu> <45B7561C.9000102@yahoo.com.au> <Pine.LNX.4.64.0701240657130.9696@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701240657130.9696@schroedinger.engr.sgi.com>
X-No-Junk-Mail: I do not want to get *any* junk mail.
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Jan 24, 2007 at 06:58:42AM -0800, Christoph Lameter wrote:
> On Wed, 24 Jan 2007, Nick Piggin wrote:
> 
> > I can't argue that a smaller pagecache will be subject to a
> > higher turnaround given the same workload, but I don't know why
> > that would be a good thing.
> 
> Neither do I. Wonder why we need this but I keep getting 
> these requests. Could we either find a reason for limiting the pagecache 
> or get this out of our system for good?

I think this paints with too broad a brushstroke...

Simply limiting the page cache with no regard to the potential
for particular content to be later reused seems a rather
pointless exercise which is guaranteed to diminish system
performance.

It would be far more useful if an application could hint to the
pagecache as to which files are and which files as not worth
caching, especially when the application knows a priori that data
from a particular file will or will not ever be reused.

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
