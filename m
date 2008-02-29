Return-Path: <linux-kernel-owner+w=401wt.eu-S934151AbYB2VoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151AbYB2VoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759253AbYB2VoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:44:09 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:50193 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758388AbYB2VoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:44:08 -0500
Date: Fri, 29 Feb 2008 16:44:07 -0500
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080229214407.GC1289@csclub.uwaterloo.ca>
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 07:38:12PM +0100, Pierre Ossman wrote:
> +/*
> + * The minimum number of ticks needed to not oscillate faster than
> + * 500 Hz.
> + */
> +#define MIN_DEEP_INTERVAL (HZ / 500)

What happens here if HZ < 500?  Or does the fact that you have less than
500HZ jiffies automatically imply that you can't go to sleep more than
the jiffy rate times per second?

--
Len Sorensen
