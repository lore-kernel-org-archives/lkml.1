Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbYCGC1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbYCGC1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763581AbYCGC1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:27:30 -0500
Received: from relay2.sgi.com ([192.48.171.30]:41784 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759153AbYCGC13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:27:29 -0500
Date: Thu, 6 Mar 2008 18:27:12 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <20080307022537.GC21185@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803061827040.29527@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
 <84144f020803031330i2c0ea1f6kc5b02c8b26145797@mail.gmail.com>
 <Pine.LNX.4.64.0803031331340.4375@schroedinger.engr.sgi.com>
 <47CC6F30.50802@cs.helsinki.fi> <20080305002821.GD1510@wotan.suse.de>
 <Pine.LNX.4.64.0803051254570.30742@schroedinger.engr.sgi.com>
 <20080306024904.GA27150@wotan.suse.de> <Pine.LNX.4.64.0803061451230.16212@schroedinger.engr.sgi.com>
 <20080307020443.GA21185@wotan.suse.de> <Pine.LNX.4.64.0803061816430.28976@schroedinger.engr.sgi.com>
 <20080307022537.GC21185@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Nick Piggin wrote:

> > Is that really a noteworthy effect?
> 
> Yes.

Numbers?

