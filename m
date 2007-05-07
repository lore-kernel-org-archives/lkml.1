Return-Path: <linux-kernel-owner+w=401wt.eu-S966308AbXEGT0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966308AbXEGT0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966297AbXEGT0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:26:17 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966293AbXEGT0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:26:16 -0400
Date: Mon, 7 May 2007 12:26:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [resend] [git pull] DRM patches for 2.6.22-rc1 (fwd)
In-Reply-To: <Pine.LNX.4.64.0705071152000.18531@skynet.skynet.ie>
Message-ID: <alpine.LFD.0.98.0705071224240.3802@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0705071152000.18531@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 May 2007, Dave Airlie wrote:
>
>    20 files changed, 196 insertions(+), 349 deletions(-)

That looked promising, but I think you generated the diffstat the wrong 
way around. It was actually

 20 files changed, 349 insertions(+), 196 deletions(-)
 delete mode 100644 drivers/char/drm/via_mm.h

so you should check your script (and add a "--summary -M" flag to the 
command that generated the diffstat)

		Linus
