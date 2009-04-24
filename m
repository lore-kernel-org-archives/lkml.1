Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbZDXOFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbZDXOFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759505AbZDXOE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:04:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52006 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbZDXOE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:04:56 -0400
Date: Fri, 24 Apr 2009 15:04:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Sachin Sant <sachinp@in.ibm.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       peterz@infradead.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: Next April 24 : BUG: lock held at task exit time!
Message-ID: <20090424140445.GL8633@ZenIV.linux.org.uk>
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au> <49F1626D.6080102@in.ibm.com> <20090424175509.561c96ad.sfr@canb.auug.org.au> <Pine.LNX.4.64.0904241249180.20196@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904241249180.20196@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 12:55:44PM +0100, Hugh Dickins wrote:

> Indeed, thanks for the headsup Stephen.  My own config gives, not
> Sachin's message (or not still visibly on screen anyway), but an
> outright panic.  Shame that leaked out into the big world, we'd
> all have preferred a quiet fixup!  Here's a patch, which I'll
> also send as reply to the relevant thread.

Applied, will fold on reorder (since Ingo is asking for what will amount
to reorder anyway).
