Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZCODE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZCODE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZCODEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:04:48 -0400
Received: from phunq.net ([64.81.85.152]:39356 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750903AbZCODEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:04:47 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sat, 14 Mar 2009 20:03:26 -0700
User-Agent: KMail/1.9.9
Cc: tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903121424.08961.phillips@phunq.net> <20090312233822.GK11935@one.firstfloor.org>
In-Reply-To: <20090312233822.GK11935@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142003.26230.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Andi Kleen wrote:
> On Thu, Mar 12, 2009 at 02:24:08PM -0700, Daniel Phillips wrote:
> > On Thursday 12 March 2009, Andi Kleen wrote:
> > > to be honest the estimate of adding btree directories in 3kLOC
> > > of code seems very optimistic.
> > 
> > Is that a bet?
> 
> No, just a general comment comparing with other read/write btree
> implementations.

Htree is about 1650 lines in Ext3.  The Tux3 implementation does not
have to implement its own custom btree code because it can use the
generic tux3/btree.c code (with index node operations generalized as
leaf operations already are).  The Tux3 implementation will be shorter
if anything, because of using the generic btree code, no need for
backward compatibility, and having had several years to think about
how to handle the NFS readdir issue more compactly.

So I guess the Tux3 directory btree will come in somewhere around
1500 lines.

Regards,

Daniel
