Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbYAPWBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbYAPWBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYAPWBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:01:10 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44257 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751576AbYAPWBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:01:09 -0500
Date: Wed, 16 Jan 2008 14:01:08 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: SLUB: Increasing partial pages
In-Reply-To: <20080116214127.GA11559@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0801161347160.11353@schroedinger.engr.sgi.com>
References: <20080116195949.GO18741@parisc-linux.org>
 <Pine.LNX.4.64.0801161219050.9694@schroedinger.engr.sgi.com>
 <20080116214127.GA11559@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008, Matthew Wilcox wrote:

> I sent you a mail on December 6th ... here are the contents of that
> mail:

Dec 6th? I was on vacation then and it seems that I was unable to 
reproduce the oopses. Can I get some backtraces or other information 
that would allow me to diagnose the problem?

> Applying just patches 1-7 and 9 leads to a slight (0.34%) performance
> reduction compared to slub.  That is 6.45% versus slab, reduces to 6.79%
> with the 8 patches applied.

Patch 8 is the one that optimizes the fastpath. How much runtime 
variability have these tests?
