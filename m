Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0CBXJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:09:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347Ab0CBXJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:09:38 -0500
Date: Tue, 2 Mar 2010 15:09:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@linux.ie>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm request 2
In-Reply-To: <alpine.LFD.2.00.1003021505000.3616@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003021506320.3616@localhost.localdomain>
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain> <alpine.DEB.2.00.1003022300320.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003021505000.3616@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Mar 2010, Linus Torvalds wrote:
> 
> It's still code. And if the user didn't ask for it, it should damn well 
> not be there.

And I repeat: unless the feature cures cancer, it's not on by default.

Sometimes we split up _old_ features as config options, or do things that 
are meant to be turned off only for embedded people. THEN we use that 
whole 'default y' thing, because doing a "make oldconfig" should give you 
the same configuration you had before. 

But if it's not an old feature that used to not have a config option at 
all, and it doesn't cure cancer, you never EVER do "default y".  Because 
when I do "make oldconfig", and I see a "Y" default, it makes me go "I'm 
not pulling that piece of sh*t".

		Linus
