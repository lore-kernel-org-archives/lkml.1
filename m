Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYCLPUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYCLPUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYCLPUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:20:42 -0400
Received: from mail.vyatta.com ([216.93.170.194]:51522 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbYCLPUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:20:41 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.42
Date: Wed, 12 Mar 2008 08:20:31 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Message-ID: <20080312082031.7a0034af@extreme>
In-Reply-To: <20080312144701.GZ15804@mit.edu>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
	<Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz>
	<47D7B428.6010804@davidnewall.com>
	<20080312144701.GZ15804@mit.edu>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 10:47:01 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Mar 12, 2008 at 09:14:56PM +1030, David Newall wrote:
> > It should be said that X implements auto-repeat out of necessity.  While
> > the kernel can report key down and up events, its further interpretation
> > of those events is not appropriate.  Many combinations of events are
> > possible, such as keyboard plus mouse, and this precludes the kernel
> > from providing a full interpretation.  It would be wrong for it to even
> > try.  X is the proper place to implement auto-repeat for X.
> 
> The problem is that under heavy load the auto-repeat problem is real;
> I've seen it as well, and it means that I've started to try to avoid
> "make -j4" since that's a great way to trigger it.
> 
> 						- Ted

I reported a bug on this http://bugzilla.kernel.org/show_bug.cgi?id=10163
It seemed to be related to group scheduler config option.
