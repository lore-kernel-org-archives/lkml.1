Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYHVQcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYHVQcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYHVQcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:32:15 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:57538 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYHVQcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:32:14 -0400
Date: Fri, 22 Aug 2008 12:32:12 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-parisc@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch] vsprintf: use new vsprintf symbolic function pointer
	format
Message-ID: <20080822163212.GE1563@phobos.i.cabal.ca>
References: <200808220934.44782.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808220934.44782.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 09:34:43AM -0600, Bjorn Helgaas wrote:
> Use the '%pF' format to get rid of an "#ifdef DEBUG" and make
> some printks atomic.
> 
> This removes the last in-tree uses of print_fn_descriptor_symbol().
> I marked print_fn_descriptor_symbol() deprecated and scheduled it
> for removal next year to give time for out-of-tree modules to be
> updated.
> 
> I cc'd the parisc folks because print_fn_descriptor_symbol() is
> currently broken there (it needs to dereference the function pointer
> similar to ia64 and power).  This patch shouldn't make anything worse,
> but it means we need to fix dereference_function_descriptor() instead
> of print_fn_descriptor_symbol() to get meaningful initcall_debug
> output.
> 

Yeah, I sent a few patches a couple months ago fixing this up for
print_fn_..._symbol, but they were never applied, and I kind of forgot
about them. It only really effects me once and a while during a merge
window when I need to use initcall_debug, so it's easily forgotten.

I've got a patch, I'll send it along in a bit when one of my machines
finally boots and I can test it.

regards, Kyle
