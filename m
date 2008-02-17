Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYBQSUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYBQSUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYBQST4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:19:56 -0500
Received: from iabervon.org ([66.92.72.58]:46310 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYBQST4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:19:56 -0500
Date: Sun, 17 Feb 2008 13:19:55 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 2.6.23] no vga console and no messages
In-Reply-To: <alpine.LNX.1.00.0802171250480.5496@iabervon.org>
Message-ID: <alpine.LNX.1.00.0802171316120.5816@iabervon.org>
References: <alpine.LNX.1.00.0802162042130.6093@iabervon.org> <E1JQe5R-0001cW-1a@faramir.fjphome.nl> <alpine.LNX.1.00.0802171134350.5496@iabervon.org> <200802171848.16969.elendil@planet.nl> <alpine.LNX.1.00.0802171250480.5496@iabervon.org>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can tell, the only differences in either dmesg or lspci 
between the broken one and the working one are the phrasing of messages, 
not what's happening.

Out of curiousity, what do you see for the "Console: " line when you boot? 
It's possible that the VGA console code somehow got broken for both of 
us in 2.6.23, and this means that (a) my console doesn't work, since I'm 
trying to use it, and (b) if your framebuffer console tries to match your 
VGA console, it'll break, because your VGA console is broken.

	-Daniel
*This .sig left intentionally blank*
