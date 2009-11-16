Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZKPRMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZKPRMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZKPRMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:12:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbZKPRMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:12:33 -0500
Date: Mon, 16 Nov 2009 18:12:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: fix wrong synaptics detection in
 psmouse_extensions()
In-Reply-To: <20091116170151.GA24026@core.coreip.homeip.net>
Message-ID: <alpine.LSU.2.00.0911161806580.15039@wotan.suse.de>
References: <alpine.LSU.2.00.0911161245570.15039@wotan.suse.de> <20091116170151.GA24026@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ fixed linux-input CC which I have typoed previously ]

On Mon, 16 Nov 2009, Dmitry Torokhov wrote:

> On Mon, Nov 16, 2009 at 12:51:30PM +0100, Jiri Kosina wrote:
> > Commit b7802c5c1ea ("Input: psmouse - use boolean type") caused the 
> > synaptics_hardware variable to be completely useless, as it is constantly 
> > set to 'true' throughout the whole psmouse_extensions(). This was caused 
> > by the following hunk in the commit in question
> > 
> > 	-       int synaptics_hardware = 0;
> > 	+       bool synaptics_hardware = true;
> > 
> > which is wrong. Fix that up.
> 
> Hmm, not sure what I was thinnking at that time but it is obviously I
> should have stayed away form tehe keyboard...
> 
> Applied, thank you Jiri.

I guess you will be pushing that one to .32 still, right? I think it's 
quite crucial fix, so if it doesn't make it in time for .32 (I am not sure 
whether Linus will be doing next -rc or not), it should go to -stable for 
.32 right away.

Thanks!

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
