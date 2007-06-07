Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXFGHBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXFGHBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXFGHBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:01:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526AbXFGHBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:01:32 -0400
Date: Thu, 7 Jun 2007 00:01:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm2
Message-Id: <20070607000125.40ba8dc6.akpm@linux-foundation.org>
In-Reply-To: <20070607065544.GR6909@holomorphy.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070607064231.GQ6909@holomorphy.com>
	<20070606235131.a56242cd.akpm@linux-foundation.org>
	<20070607065544.GR6909@holomorphy.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 23:55:44 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> On Wed, 6 Jun 2007 23:42:31 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
> >> create-the-zone_movable-zone.patch breaks the build on sparc32.
> 
> On Wed, Jun 06, 2007 at 11:51:31PM -0700, Andrew Morton wrote:
> > Nope, there are no instances of GFP_HIGH_MOVABLE in the tree once all
> > patches are applied.  You hit a bad bisection point: between
> > create-the-zone_movable-zone.patch and
> > create-the-zone_movable-zone-fix.patch.
> 
> The fully-applied tree fails with a link error having to do with
> movable_zone. I'm not entirely sure what arches are supposed to do
> about that.
> 

config, please?
