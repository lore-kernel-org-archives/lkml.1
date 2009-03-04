Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZCDXWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZCDXWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZCDXWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:22:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:36741 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZCDXWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:22:14 -0500
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
 breaks resume from RAM on PowerBook
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090304083859.GB6889@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 10:22:04 +1100
Message-Id: <1236208924.6696.72.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 09:38 +0100, Gaudenz Steinlin wrote:
> Hi Benjamin
> 
> The commit 1fb25cb8b83e85f5bf1a4adb3c9a254c4ce92405 "radeonfb: Fix resume 
> from D3Cold on some platforms" breaks resume from suspend to RAM on my
> PowerBook (Model PowerBook5,8 with ATI Mobility Radeon 9600 M10).
> 
> On resume the pulsing led indicating sleep just changes to solid white
> and nothing else happens. 
> 
> Reverting this commit on top of the current Linus' tree fixes resume.
> 
> Gaudenz

Does it help if you comment out the call to:

	pmac_set_early_video_resume(radeonfb_early_resume, rinfo);

>From radeonfb_pm_init() ?

Cheers,
Ben.


