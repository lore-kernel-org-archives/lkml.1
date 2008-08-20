Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYHTCww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYHTCww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 22:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYHTCwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 22:52:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42529 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYHTCwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 22:52:42 -0400
Date: Wed, 20 Aug 2008 04:54:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Len Brown <lenb@kernel.org>,
       Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] PNP debugging rework
Message-ID: <20080820025427.GQ9807@one.firstfloor.org>
References: <20080819225310.28206.1011.stgit@tigger.helgaas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819225310.28206.1011.stgit@tigger.helgaas>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 04:53:10PM -0600, Bjorn Helgaas wrote:
> These patches add support for a boot-time switch to enable PNP debug
> messages.  Currently, users have to recompile with CONFIG_PNP_DEBUG=y
> to get PNP debug messages.
> 
> I copied the implementation strategy from Greg KH's USB patches:
>     http://lkml.org/lkml/2008/8/8/529
> 
> These patches don't fix any bugs, and I know it's pretty late to
> consider new stuff for 2.6.27.  The only reason to even consider them
> is that 2.6.27 includes a significant PNP rewrite, and if 2.6.27 ends
> up in a distro kernel, it will be much easier to work on problems if
> users can collect debug information without rebuilding the kernel.

I would have pushed them up because they look harmless enough,
but after Linus' recent rant on merging windows on linux-kernel I've 
reconsidered.  Will queue them for .28 in test.

-Andi (Chicken) 
