Return-Path: <linux-kernel-owner+w=401wt.eu-S1765354AbXHVSr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765354AbXHVSr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763709AbXHVSrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:47:18 -0400
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:26630 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763365AbXHVSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:47:17 -0400
X-YMail-OSG: PH1nE6kVM1l4LiR1a.ELjlU4iJUqO8zXTnlJ.c2k720wl3VZWqjMsuC8Mx8Tn98eJm2epW2BWQ--
X-RocketYMMF: rancidfat
Date: Wed, 22 Aug 2007 11:47:16 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Pavel Machek <pavel@ucw.cz>, Casey Schaufler <casey@schaufler-ca.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070822080533.GA2482@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <486902.58063.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pavel Machek <pavel@ucw.cz> wrote:

> 
> > > but you written it in wrong language. You
> > > written it in C, while you should have written it in SELinux policy
> > > language (and your favourite scripting language as frontend).
> > 
> > I have often marvelled at the notion of a simplification layer.
> > I believe that you build complex things on top of simple things,
> > not the other way around.
> 
> As we have to maintain selinux, anyway, I don't see why simplification
> layer is a problem.

It's an issue if you want to do simple things, have the resources to
do simple things, but go over budget because the simple things are
built on top of complex things that you don't need. I see this crop
up frequently with IT infrastructures, where simple problems get
solved using completely unnecessary components just because those
components are available. If you want to maintain an SELinux policy
that looks like it does smackish things in addition to the reference
policy that's OK by me.


Casey Schaufler
casey@schaufler-ca.com
