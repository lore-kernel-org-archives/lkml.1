Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbXAVTRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbXAVTRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932389AbXAVTRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:17:03 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:45541 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932379AbXAVTRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:17:01 -0500
Date: Mon, 22 Jan 2007 11:15:46 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Aubrey Li <aubreylee@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [RPC][PATCH 2.6.20-rc5] limit total vfs page cache
In-Reply-To: <45B19483.6010300@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0701221114060.25121@schroedinger.engr.sgi.com>
References: <6d6a94c50701171923g48c8652ayd281a10d1cb5dd95@mail.gmail.com> 
 <45B0DB45.4070004@linux.vnet.ibm.com>  <6d6a94c50701190805saa0c7bbgbc59d2251bed8537@mail.gmail.com>
  <45B112B6.9060806@linux.vnet.ibm.com>  <6d6a94c50701191804m79c70afdo1e664a072f928b9e@mail.gmail.com>
  <45B17D6D.2030004@yahoo.com.au> <6d6a94c50701191908i63fe7eebi9a97a4afb94f5df4@mail.gmail.com>
 <45B19483.6010300@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jan 2007, Nick Piggin wrote:

> > It doesn't reduce the amount of memory available to the system. It
> > just reduce the amount of memory available to the page cache. So that
> > page cache is limited and the reserved memory can be allocated by the
> > application.
> 
> But the patch doesn't do that, as I explained.

The patch could do it if he would be checking NR_FILE_PAGES against 
a limit instead of the free pages.

