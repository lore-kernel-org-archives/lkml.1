Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbXK0WCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbXK0WCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758286AbXK0WCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:02:11 -0500
Received: from relay1.sgi.com ([192.48.171.29]:51056 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757379AbXK0WCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:02:09 -0500
Date: Tue, 27 Nov 2007 14:02:08 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Mosberger-Tang <dmosberger@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for
 per cpu access
In-Reply-To: <ed5aea430711271327l1644750dm363f846a23b1cce5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711271401350.4803@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com>  <20071127001430.083503280@sgi.com>
  <ed5aea430711262120p45bb5b2t1b16872e74547369@mail.gmail.com> 
 <Pine.LNX.4.64.0711271014550.2310@schroedinger.engr.sgi.com> 
 <ed5aea430711271310i144c005cj25101b7dd6b0d6d9@mail.gmail.com> 
 <Pine.LNX.4.64.0711271316110.4590@schroedinger.engr.sgi.com>
 <ed5aea430711271327l1644750dm363f846a23b1cce5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, David Mosberger-Tang wrote:

> Code-size reduction?  You must be talking *source* code size
> reduction.  Surely the small-data access-method decreases object code
> size.

Yes source code reduction. I just added the attribute back but in such a 
way that any arch can add attributes to per cpu definitions.

