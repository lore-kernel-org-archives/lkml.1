Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbZFVSqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbZFVSqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZFVSqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:46:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbZFVSqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:46:44 -0400
Date: Mon, 22 Jun 2009 11:44:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bernd Schmidt <bernds_cb1@t-online.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Blackfin Architecture Team 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       David Howells <dhowells@redhat.com>, stable@kernel.org
Subject: Re: Fix for shared flat binary format in 2.6.30
In-Reply-To: <4A3F5EAE.7020402@t-online.de>
Message-ID: <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain>
References: <4A3F5EAE.7020402@t-online.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Jun 2009, Bernd Schmidt wrote:
>
> This fixes a crash in 2.6.30 with shared flat binaries.  prepare_binfmt now
> requires a cred pointer to be set up, which isn't done in binfmt_flat.c.

This has so many bugs in patch submission that I literally almost gave up 
despite it being a trivial patch.

Attachements, wrong separators between explanation, wrong patch format 
(hint: use "-p1" or some sane patch system that gets things right 
_without_ crap), you name it. Very irritating.

I'm generally not interested in cleaning up after people who can't bother 
to try to make patches in the right format. If you can't bother to spend 
the small amount of time to make sure the patch is properly formatted, why 
should I bother to apply it?

It literally looks like you used SVN to generate that sh*t-for-brains 
patch. If you have to use svn, at least learn to make it generate proper 
patches.

(How? I don't know. Maybe "svn diff -p1" works? Why would _anybody_ ever 
use SVN for the kernel anyway? The "S" stands for "Substandard").

I applied this patch, but I want to just vent my frustration with it.

		Linus
