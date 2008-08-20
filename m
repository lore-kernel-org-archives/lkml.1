Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYHTO57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYHTO57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYHTO5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:57:49 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:25301 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYHTO5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:57:48 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/8] PNP debugging rework
Date: Wed, 20 Aug 2008 08:57:42 -0600
User-Agent: KMail/1.9.9
Cc: Len Brown <lenb@kernel.org>, Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080819225310.28206.1011.stgit@tigger.helgaas> <20080820025427.GQ9807@one.firstfloor.org>
In-Reply-To: <20080820025427.GQ9807@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808200857.44056.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008 08:54:27 pm Andi Kleen wrote:
> On Tue, Aug 19, 2008 at 04:53:10PM -0600, Bjorn Helgaas wrote:
> > These patches add support for a boot-time switch to enable PNP debug
> > messages.  Currently, users have to recompile with CONFIG_PNP_DEBUG=y
> > to get PNP debug messages.
> > 
> > I copied the implementation strategy from Greg KH's USB patches:
> >     http://lkml.org/lkml/2008/8/8/529
> > 
> > These patches don't fix any bugs, and I know it's pretty late to
> > consider new stuff for 2.6.27.  The only reason to even consider them
> > is that 2.6.27 includes a significant PNP rewrite, and if 2.6.27 ends
> > up in a distro kernel, it will be much easier to work on problems if
> > users can collect debug information without rebuilding the kernel.
> 
> I would have pushed them up because they look harmless enough,
> but after Linus' recent rant on merging windows on linux-kernel I've 
> reconsidered.  Will queue them for .28 in test.

Fair enough, thanks!

Bjorn
