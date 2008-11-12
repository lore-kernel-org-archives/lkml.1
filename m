Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbYKLR1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYKLR1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYKLR1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:27:14 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52626 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYKLR1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:27:14 -0500
Date: Wed, 12 Nov 2008 17:27:12 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nick Warne <nick@ukfsn.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make Dell keyboard repeat quirk apply to a wider range of hardware
Message-ID: <20081112172712.GA16382@srcf.ucam.org>
References: <20081111074702.75e71055@sauron.linicks.net> <20081112131427.1bbc2a7c@palantir.linicks.net> <20081112165650.GA15594@srcf.ucam.org> <20081112172429.674c4ff3@palantir.linicks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112172429.674c4ff3@palantir.linicks.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 05:24:29PM +0000, Nick Warne wrote:

> But how you determine if these certain laptops produce a keypress
> release I don't know with having all of them at hand...

The quirk is only applied to a small number of keys which wouldn't want 
autorepeat anyway, so it's pretty clearly harmless even if the hardware 
works sanely.

> So it needs BOTH 'Dell Inc.' and 'Dell Computer Corporation' to cover
> these laptops (I guess), as per the info I got from people running
> dmidecode:

That's what the patch adds. I don't have appropriate hardware to test.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
