Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbXFGGy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbXFGGy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXFGGyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:54:50 -0400
Received: from holomorphy.com ([66.93.40.71]:34537 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbXFGGyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:54:49 -0400
Date: Wed, 6 Jun 2007 23:55:44 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm2
Message-ID: <20070607065544.GR6909@holomorphy.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070607064231.GQ6909@holomorphy.com> <20070606235131.a56242cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606235131.a56242cd.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 23:42:31 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>> create-the-zone_movable-zone.patch breaks the build on sparc32.

On Wed, Jun 06, 2007 at 11:51:31PM -0700, Andrew Morton wrote:
> Nope, there are no instances of GFP_HIGH_MOVABLE in the tree once all
> patches are applied.  You hit a bad bisection point: between
> create-the-zone_movable-zone.patch and
> create-the-zone_movable-zone-fix.patch.

The fully-applied tree fails with a link error having to do with
movable_zone. I'm not entirely sure what arches are supposed to do
about that.


-- wli
