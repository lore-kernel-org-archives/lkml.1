Return-Path: <linux-kernel-owner+w=401wt.eu-S1766940AbXDSTJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766940AbXDSTJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766944AbXDSTJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:09:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56804 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766940AbXDSTJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:09:11 -0400
Subject: Re: [RFC 0/8] Variable Order Page Cache
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 12:09:28 -0700
Message-Id: <1177009768.19676.0.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 09:35 -0700, Christoph Lameter wrote:
> Variable Order Page Cache Patchset
> 

..
mm/built-in.o: In function `__generic_file_aio_write_nolock':
filemap.c:(.text+0x295c): undefined reference to `page_cache_shift'
filemap.c:(.text+0x296c): undefined reference to `page_cache_shift'
fs/built-in.o: In function `simple_commit_write':
(.text+0x20866): undefined reference to `page_cache_shift'
fs/built-in.o: In function `simple_prepare_write':
(.text+0x2097b): undefined reference to `page_cache_size'
fs/built-in.o: In function `simple_prepare_write':
(.text+0x209cd): undefined reference to `page_cache_size'


Thanks,
Badari

