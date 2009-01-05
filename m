Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbZAELGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbZAELGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZAELGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:06:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60931 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZAELGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:06:07 -0500
Date: Mon, 5 Jan 2009 11:05:56 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Tino Keitel <tino.keitel@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       trenn@suse.de, jbarnes@virtuousgeek.org
Subject: Re: 2.6.28 regression: xbacklight broken on ThinkPad X61s
Message-ID: <20090105110556.GA28245@srcf.ucam.org>
References: <20090105083911.GA3694@x61> <1231146375.32473.52.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231146375.32473.52.camel@rzhang-dt>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 05:06:15PM +0800, Zhang Rui wrote:

> hmm, this regression is caused by commit 
> 22c13f9d8179f4c9caecfcb60a95214562b9addc
> 
> but the real problem is that the IGD OpRegion doesn't work well on this
> laptop.

I suspect that the issue is actually that the opregion code works fine 
but i915 interrupts are failing to work properly, which we've seen a 
couple of cases of. Jesse?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
