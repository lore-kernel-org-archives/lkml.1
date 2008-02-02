Return-Path: <linux-kernel-owner+w=401wt.eu-S1762532AbYBBB3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762532AbYBBB3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbYBBB3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:29:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:60534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668AbYBBB3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:29:34 -0500
Date: Sat, 2 Feb 2008 02:29:29 +0100
From: Nick Piggin <npiggin@suse.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
Message-ID: <20080202012929.GA30847@wotan.suse.de>
References: <1201829922.23523.68.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201829922.23523.68.camel@brick>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:38:42PM -0800, Harvey Harrison wrote:
> ---------------------------
> Ping?
> What:	vm_ops.nopage
> When:	Soon, provided in-kernel callers have been converted
> Why:	This interface is replaced by vm_ops.fault, but it has been around
> 	forever, is used by a lot of drivers, and doesn't cost much to
> 	maintain.
> Who:	Nick Piggin <npiggin@suse.de>

Well the in-kernel callers have not all been converted yet. I have
actually done the work, but it needs testing and merging by maintainers.
Getting it done during this merge window would be nice, I'm going to
try to make that happen after I get back from LCA. Otherwise probably
2.6.26.
