Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYAPWel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYAPWel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYAPW2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:28:47 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45186 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757892AbYAPW2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:28:45 -0500
Date: Wed, 16 Jan 2008 14:28:44 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: SLUB: Increasing partial pages
In-Reply-To: <20080116221618.GB11559@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0801161421240.12024@schroedinger.engr.sgi.com>
References: <20080116195949.GO18741@parisc-linux.org>
 <Pine.LNX.4.64.0801161219050.9694@schroedinger.engr.sgi.com>
 <20080116214127.GA11559@parisc-linux.org> <Pine.LNX.4.64.0801161347160.11353@schroedinger.engr.sgi.com>
 <20080116221618.GB11559@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008, Matthew Wilcox wrote:

> About 0.1-0.2%  0.3% is considered significant.

The results are that stable? A kernel compilation which slightly 
rearranges cachelines due to code and data changes typically leads to a 
larger variance on my 8 way box (gets even larger under NUMA). I would 
expect that the variations on a database load would be more significant.

I repeatedly saw patches from Intel to do minor changes to SLAB that 
increase performance by 0.5% or so (like the recent removal of a BUG_ON 
for performance reasons). These do not regress again when you build a 
newer kernel release?
