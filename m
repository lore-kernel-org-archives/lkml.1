Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYI3Mle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYI3Mle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYI3MlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:41:25 -0400
Received: from twin.jikos.cz ([213.151.79.26]:58621 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbYI3MlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:41:24 -0400
Date: Tue, 30 Sep 2008 14:40:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org, kkeil@suse.de,
       agospoda@redhat.com, arjan@linux.intel.com, david.graham@intel.com,
       Bruce Allan <bruce.w.allan@intel.com>, john.ronciak@intel.com,
       Thomas Gleixner <tglx@linutronix.de>, chris.jones@canonical.com,
       tim.gardner@intel.com, airlied@gmail.com,
       Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: [RFC PATCH 11/12] e1000e: write protect ICHx NVM to prevent
 malicious write/erase
In-Reply-To: <20080930032013.22950.70966.stgit@jbrandeb-bw.jf.intel.com>
Message-ID: <Pine.LNX.4.64.0809301439021.2307@twin.jikos.cz>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
 <20080930032013.22950.70966.stgit@jbrandeb-bw.jf.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Jesse Brandeburg wrote:

> Set the hardware to ignore all write/erase cycles to the GbE region in
> the ICHx NVM.  This feature can be disabled by the WriteProtectNVM module
> parameter (enabled by default) though that is not recommended.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

I guess there is no chance to have kernel somehow notified when 
write/erase cycle is unsuccessfully tried, is it? This way, it would also 
make chasing the root cause easier.

Thanks,

-- 
Jiri Kosina
SUSE Labs

