Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZDUA2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZDUA2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZDUA2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:28:25 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34589 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420AbZDUA2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:28:25 -0400
Date: Mon, 20 Apr 2009 20:26:49 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections
 -fdata-sections
In-Reply-To: <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009, Linus Torvalds wrote:

> Because I absolutely hate the tools issues that I'm convinced will 
> happen the moment I merge it.

I assume you're only worried about toolchain problems for people who are 
actually using the -ffunction-sections option.  Would it help if the 
-ffunction-sections compilation option were marked as experimental until 
proven otherwise?

If you're not willing to merge even an experimental option for 
-ffunction-sections, would you at least be willing to merge the first 
three patches in the patch series?  Compiling with -ffunction-sections 
would not be supported by the mainline kernel, so any toolchain issues 
with it would not be your problem.  But any vendor that wants to take 
advantage of -ffunction-sections would still be able to use it without 
having to maintain 300 lines of scattered changes to the kernel.

	-Tim Abbott


