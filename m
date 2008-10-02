Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYJBNDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYJBNDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYJBNDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:03:18 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34788 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbYJBNDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:03:17 -0400
Date: Thu, 2 Oct 2008 15:02:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
cc: torvalds@linux-foundation.org, jeff@garzik.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       arjan@linux.intel.com, Bruce Allan <bruce.w.allan@intel.com>,
       arjan@linux.intel.com
Subject: Re: [PATCH] e1000e: write protect ICHx NVM to prevent malicious
 write/erase
In-Reply-To: <20081002001835.5951.82533.stgit@jbrandeb-bw.jf.intel.com>
Message-ID: <Pine.LNX.4.64.0810021500470.1887@twin.jikos.cz>
References: <20081002001830.5951.3123.stgit@jbrandeb-bw.jf.intel.com>
 <20081002001835.5951.82533.stgit@jbrandeb-bw.jf.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008, Jesse Brandeburg wrote:

> From: Bruce Allan <bruce.w.allan@intel.com>
> 
> Set the hardware to ignore all write/erase cycles to the GbE region in
> the ICHx NVM.  This feature can be disabled by the WriteProtectNVM module
> parameter (enabled by default) only after a hardware reset, but
> the machine must be power cycled before trying to enable writes.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> CC: arjan@linux.intel.com

Does this impose any user-visible behavior change? (such as not being able 
to set up wake-on-lan, change MAC address, whatever).

-- 
Jiri Kosina
SUSE Labs

