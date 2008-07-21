Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYGUEVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYGUEVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYGUEV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:21:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbYGUEV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:21:26 -0400
Date: Sun, 20 Jul 2008 21:21:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
cc: linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Re: Suspend to RAM regression (bisected)
In-Reply-To: <20080721020349.GA4328@localhost>
Message-ID: <alpine.LFD.1.10.0807202119240.31863@woody.linux-foundation.org>
References: <20080721020349.GA4328@localhost>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 20 Jul 2008, Carlos R. Mafra wrote:
> 
> I bisected this regression down to c0e09200dc0813972442e550a5905a132768e56c
> ("drm: reorganise drm tree to be more future proof"), and I checked that
> reverting this commit (it reverts cleanly) really makes the regression go
> away.

Hmm. That did almost only just renames, so maybe it's fixed by the pull I 
just did that added the commit "gpu: re-order GPU subdirectory vs char for 
AGP vs DRM startup".

I _just_ pushed out the end result, so it should be in my git tree in a 
couple of minutes when the mirroring finishes.

		Linus
