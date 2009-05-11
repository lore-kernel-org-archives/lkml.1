Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZEKSjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZEKSjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZEKSiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:38:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260AbZEKSiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:38:54 -0400
Date: Mon, 11 May 2009 11:35:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: oleg@redhat.com, roland@redhat.com, vmayatsk@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] do_wait cleanupe (more to come)
Message-Id: <20090511113505.ca9384af.akpm@linux-foundation.org>
In-Reply-To: <20090511122233.GE13954@elte.hu>
References: <20090507064630.GA15847@redhat.com>
	<20090507131234.adf90d1b.akpm@linux-foundation.org>
	<20090511122233.GE13954@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 14:22:33 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 7 May 2009 08:46:30 +0200
> > Oleg Nesterov <oleg@redhat.com> wrote:
> > 
> > > Slightly tested. Definitely this needs more testing, but since a) the
> > > second patch was reviewed by Ingo and b) Andrew likes the buggy patches
> > > very much, I am sending this series. At least I believe this all is
> > > right "in general".
> > 
> > Worried.  This hits on ptrace and there's a lot of ptrace work 
> > pending, including large changes which are threatening to come in 
> > via a different tree (security).
> > 
> > If we end up with marginal/flakey patches in the middle of all of 
> > this, a big mess ensues.
> 
> This problems would be solved if all these bits were in -mm.
> 

I merged them, but that didn't solve the problem.  If more ptrace work
happens and then these patches turn out to be bad, we have a mess on
our hands.

IOW, merging "Slightly tested.  Definitely this needs more testing"
patches into an area on ongoing development is a bit risky.
