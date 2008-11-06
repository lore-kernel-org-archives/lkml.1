Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYKFP46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYKFP46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYKFP4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:56:50 -0500
Received: from molly.corsac.net ([81.57.48.219]:59701 "EHLO molly.corsac.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYKFP4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:56:50 -0500
Date: Thu, 6 Nov 2008 16:56:46 +0100
From: Yves-Alexis Perez <corsac@debian.org>
To: Tony Vroon <tony@linx.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Bernhard Schmidt <berni@birkenwald.de>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, "Carlos R. Mafra" <crmafra2@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Long delays and keystrokes required - related to disk
	encryption?
Message-ID: <20081106155646.GC16969@corsac.net>
References: <20081105020340.GA6399@schleppi.birkenwald.de> <4911B829.8040701@linux.intel.com> <1225986063.4234.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225986063.4234.10.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 03:41:03PM +0000, Tony Vroon wrote:
> As an observation, things seem to slow down as the init process in
> initramfs is loaded. First I thought it was waiting for user input in
> the initramfs that slowed down, but it turned out I needed to hit Ctrl
> once to get to even get to the input prompt.
> Enabling an initramfs and sticking a simple script in there may suffice.
> All machines affected appear to be recent (ICH7/8/9) Centrino laptops
> with HPET enabled, if that helps.

In my case, it seems to slow down as soon as the luks volume is opened
and the root fs is mounted.

Cheers,
-- 
Yves-Alexis
