Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbXFNVdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbXFNVdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXFNVc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:32:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbXFNVc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:32:56 -0400
Date: Thu, 14 Jun 2007 14:32:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
Message-Id: <20070614143248.736312f8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com>
	<20070614130645.cabdff1b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 14 Jun 2007 14:20:04 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> > I think the best way to proceed would be to investigate that _general_
> > optimisation and then, based upon the results of that work, decide whether
> > further _specialised_ changes such as variable PAGE_CACHE_SIZE are needed,
> > and if so, what they should be.
> 
> As has been pointed out performance is only one beneficial issue of
> having a higher page cache. It is doubtful in principle that the proposed 
> alternative can work given that locking overhead and management overhead
> by the VM are not minimized but made more complex by your envisioned 
> solution.

Why do we have to replay all of this?

You: conceptully-new add-on which benefits 0.25% of the user base, provided
they select the right config options and filesystem.

Me: simpler enhancement which benefits 100% of the user base (ie: includes
4k blocksize, 4k pagesize) and which also fixes your performance problem
with that HBA.


We want the 100% case.
