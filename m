Return-Path: <linux-kernel-owner+w=401wt.eu-S1764931AbYCGCeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764931AbYCGCeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762323AbYCGCdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:33:54 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55842 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761686AbYCGCdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:33:53 -0500
Date: Thu, 6 Mar 2008 18:33:35 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <20080307023315.GE21185@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803061833140.29585@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803031331340.4375@schroedinger.engr.sgi.com>
 <47CC6F30.50802@cs.helsinki.fi> <20080305002821.GD1510@wotan.suse.de>
 <Pine.LNX.4.64.0803051254570.30742@schroedinger.engr.sgi.com>
 <20080306024904.GA27150@wotan.suse.de> <Pine.LNX.4.64.0803061451230.16212@schroedinger.engr.sgi.com>
 <20080307020443.GA21185@wotan.suse.de> <Pine.LNX.4.64.0803061816430.28976@schroedinger.engr.sgi.com>
 <20080307022537.GC21185@wotan.suse.de> <Pine.LNX.4.64.0803061827040.29527@schroedinger.engr.sgi.com>
 <20080307023315.GE21185@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Nick Piggin wrote:

> On Thu, Mar 06, 2008 at 06:27:12PM -0800, Christoph Lameter wrote:
> > On Fri, 7 Mar 2008, Nick Piggin wrote:
> > 
> > > > Is that really a noteworthy effect?
> > > 
> > > Yes.
> > 
> > Numbers?
> 
> Uhh... big number > small number

Can you quantify the effect?
