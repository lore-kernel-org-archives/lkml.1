Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbXE2VAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbXE2VAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760199AbXE2VAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:00:14 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760788AbXE2VAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:00:13 -0400
Date: Tue, 29 May 2007 13:59:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bryan Wu <bryan.wu@analog.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] Blackfin update for 2.6.22-rc3
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
Message-ID: <alpine.LFD.0.98.0705291356290.26602@woody.linux-foundation.org>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 May 2007, Bryan Wu wrote:
> 
>  - Blackfin arch update including BF54x initial supporting
>  - Blackfin driver update: serial/spi/rtc
>  - Provide new Blackfin watchdog driver
>  - binfmt_flat.c for Blackfin arch modification

I realize that this all just touches blackfin-specific stuff, but after 
-rc3 I really prefer not to bother with these things..

Also, for stuff that is really just an architecture that I can't even 
test, and where there is a clear maintainership thing, I'd actually prefer 
to just do a git merge, if possible. It's not like I will likely start 
looking at some blackfin-specific patches. Judging from the diffs, you do 
actually use git, do you have a place where you could export these kinds 
of patch-series as a git tree instead?

		Linus
