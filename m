Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbZAGURW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbZAGURW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZAGURK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:17:10 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:39434 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZAGURJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:17:09 -0500
Date: Wed, 7 Jan 2009 21:18:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] KBUILD: Add script to manipulate .config files on the command line
Message-ID: <20090107201849.GH4647@uranus.ravnborg.org>
References: <20090103321.351399938@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103321.351399938@firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 03:21:41AM +0100, Andi Kleen wrote:
> 
> I often change single options in .config files. Instead of using
> an editor or one of the frontends it's convenient to do this from
> the command line. It's also useful to do from automated build scripts
> when building different variants from a base config file.
> 
> I extracted most of the CONFIG manipulation code from one of my
> build scripts into a new shell script scripts/config
> 
> The script is not integrated with the normal Kconfig machinery
> and doesn't do any checking against Kconfig files, but just manipulates
> that text format. This is always done at make time anyways.
> 
> I believe this script would be a useful standard addition for scripts/*
> 
> Sample usage:
> 
> ./scripts/config --disable smp 
> Disable SMP in .config file
> 
> ./scripts/config --file otherdir/.config --module e1000e
> Enable E1000E as module in otherdir/.config
> 
> ./scripts/config --state smp
> y 
> Check state of config option CONFIG_SMP
> 
> After merging into git please make scripts/config executable
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

When I try to run the script with no arguments nothing happens!?!

I will merge as is but please followup with a patch so it prints out usage
in this situation.

	Sam
