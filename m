Return-Path: <linux-kernel-owner+w=401wt.eu-S1763771AbXGFTWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763771AbXGFTWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762135AbXGFTVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:21:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58014 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762127AbXGFTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:21:54 -0400
Date: Fri, 6 Jul 2007 12:21:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@stusta.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mm/vmstat.c: possible cleanups
In-Reply-To: <20070706181350.GO3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707061221330.24163@schroedinger.engr.sgi.com>
References: <20070705232345.GG3492@stusta.de>
 <Pine.LNX.4.64.0707061048310.30575@schroedinger.engr.sgi.com>
 <20070706181350.GO3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Adrian Bunk wrote:

> > Hmmm... This may be needed by the cpu idle code to update the vm stats 
> > before going idle.
> 
> Since 1 year it's making the kernel image larger without having a single 
> user.
> 
> And if it will one day get a user, removing the #if 0 will be trivial.

Then just remove the whole function. the #if 0 is ugly.

