Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZC2NH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZC2NH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZC2NHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:07:08 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:55948 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbZC2NHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:07:07 -0400
Date: Sun, 29 Mar 2009 14:07:02 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: enabling kms for i915 disables brightness control and xrandr
Message-ID: <20090329130702.GA23660@sucs.org>
References: <1238322841.4185.36.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238322841.4185.36.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'ing dri-devel, Eric Anholt and Jesse Barnes)

On Sun, Mar 29, 2009 at 12:34:01PM +0200, Soeren Sonnenburg wrote:
> Dear all,
> 
> I am not sure if this is just a user error/ too old userspace problem,

[User stated that 2.6.3 intel driver is being used in another email]

> but I recognized that when I enable kernel based modesetting on a intel
> 945 based samsung nc 10 netbook, I loose brightness control from within
> X and X resolutions are wrong (instead of 1024x600 it is 1024x1024) and
> xrandr does no longer have the all the modelines ranging from 1024x600
> to 640x350... Trying to change resolutions / setting the brightness via
> xrandr results in error messages being printed. 
> 
> Furthermore, this same flag disables Xv support..
> 
> However, screen switches between terminal and X are quite fast now
> (without any flicker) and suspend and everything works stably.
> 
> I recognized that I can set the brightness via
> 
> setpci -s 00:02.1 F4.B=XX
> 
> (XX ranging from 00 to FF) just fine...
> 
> I am attaching the .config .
> 
> Any ideas?
> Soeren

-- 
Sitsofe | http://sucs.org/~sits/
