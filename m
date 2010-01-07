Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364Ab0AGUpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0AGUpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401Ab0AGUpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:45:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47244 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab0AGUpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:45:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the suspend tree with the input tree
Date: Thu, 7 Jan 2010 21:45:32 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100107150723.b07d521b.sfr@canb.auug.org.au> <20100107043040.GB2314@core.coreip.homeip.net>
In-Reply-To: <20100107043040.GB2314@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001072145.32332.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 January 2010, Dmitry Torokhov wrote:
> On Thu, Jan 07, 2010 at 03:07:23PM +1100, Stephen Rothwell wrote:
> > Hi Rafael,
> > 
> > Today's linux-next merge of the suspend tree got a conflict in
> > drivers/input/serio/serio.c between commits
> > 386d8772980be01b94bd463ea1e745732d7eb502 ("Input: serio - use device core
> > to create 'id' attribute group") and
> > ddf1ffbd40c92ff1e58c45fa96d309788f7beb60 ("Input: serio - let device core
> > tell us if device was registered") from the input tree and commit
> > f543d6795ccfbd443a042e012a6aea15e4f4c87a ("PM: Allow serio input devices
> > to suspend/resume asynchronously") from the suspend tree.
> > 
> > I fixed it up (see below) but am not sure it this is the correct fix.  I
> > can carry this fix as necessary.
> 
> I think the fix is fine, however, do we still need to do async serio
> suspend, now that we sped up resetting psmouse and atkbd? Rafael?

Well, serio suspend is about 30 ms total on my test boxes that may be
reduced to 15 ms by async.  Not much, but still.

Please let me know what you think.

Rafael
