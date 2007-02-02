Return-Path: <linux-kernel-owner+w=401wt.eu-S1030187AbXBBCOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030187AbXBBCOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 21:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030193AbXBBCOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 21:14:36 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:41061 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030187AbXBBCOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 21:14:35 -0500
Date: Thu, 1 Feb 2007 18:14:23 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: Re: [SLAB] Shutdown cache_reaper when cpu goes down
In-Reply-To: <20070201165553.848fab65.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0702011812220.9799@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702011111560.8307@schroedinger.engr.sgi.com>
 <20070201165553.848fab65.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007, Andrew Morton wrote:

> Is this bug unique to the changes in -mm, or is it in mainline?

Mainline is also affected. However, mainline may need a different fix 
since the hotplug notifier scheme was changed.

