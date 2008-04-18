Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYDREtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYDREtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 00:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYDREs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 00:48:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:6403 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYDREs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 00:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pwxv/oZImtXks17RQFBmD0ma9iUKIuPtRMYgZAB2fFviQT5dcv5GN2lltHinniQPVUYvZupF5ydixoQY5l7lD/kR9Z4Q/p1TcAo25way9vQfnfVAvjblJYSSGr8hw6f3Vj1CK0TyjZFtbZwHSdeU9BE/5PBmupF9g49xdUGngoA=
Date: Fri, 18 Apr 2008 00:48:45 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: WM97xx touchscreen updates
Message-ID: <20080418044844.GA15686@anvil.corenet.prv>
References: <20080415144535.GA20619@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415144535.GA20619@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 03:45:35PM +0100, Mark Brown wrote:
> This patch series updates the WM97xx touchscreen drivers with a couple
> of small cleanups and the addition of support for use of the WM97xx
> touchpanels to wake up from suspend.  Since the last submission I have:
> 
>  - Updated the commit message for scheduling of the interrupt handler. 
>  - Hooked the touchscreen into the driver model wakeup infrastructure.
> 
> It is also available in the git repository at:
> 
>   git://opensource.wolfsonmicro.com/linux-2.6-touch upstream
> 
> Mark Brown (3):
>       wm97xx-core: Only schedule interrupt handler if not already scheduled
>       wm97xx-core: Use IRQF_SAMPLE_RANDOM
>       wm97xx-core: Support use as a wakeup source
> 
>  drivers/input/touchscreen/wm97xx-core.c |   56 ++++++++++++++++++++++++++----
>  include/linux/wm97xx.h                  |    3 ++
>  2 files changed, 51 insertions(+), 8 deletions(-)
> 

Applied the lot, thank you Mark.

-- 
Dmitry
