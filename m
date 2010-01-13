Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977Ab0AMP7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0AMP7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885Ab0AMP7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:59:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab0AMP7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:59:13 -0500
Date: Wed, 13 Jan 2010 10:59:06 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] cpufreq: dont BUG_ON uninitialized policy cpu
Message-ID: <20100113155905.GA1965@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Wu Fengguang <fengguang.wu@intel.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100113051438.GA32519@localhost>
 <4B4DBFBC.4090400@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DBFBC.4090400@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 01:42:36PM +0100, Thomas Renninger wrote:
 > On 01/13/2010 06:14 AM, Wu Fengguang wrote:
 > > Remove a BUG_ON which is always triggered here after commit 0b19a310eebb93:
 > The patch got dropped from -mm.
 > I hope it did not make it upstream yet, otherwise it should also
 > get dropped/reverted there without replacement.
 > There wasn't a real, only a theoretical issue.
 > Looking at it again, I now think it's not needed at all.
 
dropped from cpufreq.git

I'm still curious how we're calling cpufreq_update_policy with no policy set.
I suspect cpufreq_stats might be doing something wrong.

	Dave
