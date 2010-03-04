Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab0CDSqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:46:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324Ab0CDSqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:46:07 -0500
Date: Thu, 4 Mar 2010 10:45:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100304103655.0b14343f@jbarnes-piketon>
Message-ID: <alpine.LFD.2.00.1003041044040.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <20100304103655.0b14343f@jbarnes-piketon>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Jesse Barnes wrote:
> 
> Whoa, so breaking ABI in staging drivers isn't ok?  Lots of other
> staging drivers are shipped by distros with compatible userspaces, but I
> thought the whole point of staging was to fix up ABIs before they
> became mainstream and had backwards compat guarantees, meaning that
> breakage was to be expected?

If the staging driver isn't in common use, who cares?

But this is a major driver, used by a major subsystem in a major 
distribution.

It's not like Fedora-12 is some odd case. And it's not like nVidia 
graphics is unusual.

Face it, nouveau is "staging" only in name.

			Linus
