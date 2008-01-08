Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYAHQxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYAHQxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbYAHQxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:53:06 -0500
Received: from main.gmane.org ([80.91.229.2]:55336 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbYAHQxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:53:03 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Date: Tue, 8 Jan 2008 16:52:42 +0000 (UTC)
Message-ID: <slrnfo7aiq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <Pine.LNX.4.64.0801081725480.3032@fbirervta.pbzchgretzou.qr>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-08, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> Do it step-by-step.

Still too much work.

> I can recommend that you try another distribution then.

They all suck.

>>that load drivers in wrong order etc.,
>
> What specific modules and which order do you need for the disks?
> There is also kernel-side loading order coming up:
> http://lwn.net/Articles/260856/
>
>>and are difficult to configure
>
> I do not really have to configure anything on my machine. Then again,
> yours might be vastly different. 

Typically distros' stock kernels load the intorable integrated buzz-chip
as the first sound card, and the wrong network adapter as eth0. SATA and 
USB disks appear as some randomly ordered scsi nodes, and so on. This 
could be configured with udev if one were willing to learn -- for a
fundamentally very trivial task -- yet another wheel-reinving unnecessarily
cryptic piece of shit, to tolerate distros breaking your cryptic config 
constantly, and to tolerate its intolerable slowness at boot. (/dev should
still be the UI for modifying dynamic device mappings, reacting to ln, mv,
chmod, etc., instead of being reduced into a race-condition ridden tmpfs
shadow, that loses your normally created symlinks and permissions at boot.)

But the stock kernels also takes age at boot in (trying to) load a zillion
unnecessary drivers. They need to be configured to not load them. But
_obviously_ they won't use a _simple_ listing of the modules to load
(/etc/modules), but demand complex initrd editing. And all of those tools
that I've seen and have not required too much work, have again demanded
udev. No thanks.

-- 
Tuomo

