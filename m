Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbXK0VSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbXK0VSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbXK0VSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:18:38 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43738 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757012AbXK0VSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:18:37 -0500
Date: Tue, 27 Nov 2007 13:18:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Mosberger-Tang <dmosberger@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for
 per cpu access
In-Reply-To: <ed5aea430711271310i144c005cj25101b7dd6b0d6d9@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711271316110.4590@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com>  <20071127001430.083503280@sgi.com>
  <ed5aea430711262120p45bb5b2t1b16872e74547369@mail.gmail.com> 
 <Pine.LNX.4.64.0711271014550.2310@schroedinger.engr.sgi.com>
 <ed5aea430711271310i144c005cj25101b7dd6b0d6d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, David Mosberger-Tang wrote:

> Uniformity for the sake of uniformity?  The small data addressing is
> really elegant and I don't think it should be dropped just for the
> sake of uniformity.

Uniformity for the sake of code size reduction and easier maintenance. 

Yes I think it would be great to have this feature on all arches if 
possible. If someone could work with the gcc /linker folks to get this 
done that would be great.

But the feature has been removed from gcc and so its not usable for IA64 
with a current compiler anymore. This is basically removing useless code.


