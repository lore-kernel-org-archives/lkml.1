Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYE3TNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYE3TNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 15:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYE3TNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 15:13:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42605 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYE3TNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 15:13:14 -0400
Date: Fri, 30 May 2008 14:14:14 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shaggy@us.ibm.com, sandeen@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Remove unnecessary page decrypt call
Message-ID: <20080530191414.GM7450@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080529220817.GF7450@halcrowt61p.austin.ibm.com> <20080529163643.4c2620fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529163643.4c2620fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 04:36:43PM -0700, Andrew Morton wrote:
> On Thu, 29 May 2008 17:08:17 -0500
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> 
> > The page decrypt calls in ecryptfs_write() are both pointless and
> > buggy.
> 
> buggy enough to be fixed in 2.6.26?  2.6.25.x?

I recommend this fix for 2.6.26 and 2.6.25.x.
