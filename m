Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbXEPDwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbXEPDwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758968AbXEPDwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:52:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758059AbXEPDwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:52:43 -0400
Date: Tue, 15 May 2007 20:48:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [RFC] select and dependencies in Kconfig
In-Reply-To: <20070516033335.GH4095@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0705152046070.3890@woody.linux-foundation.org>
References: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk>
 <20070516033335.GH4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 May 2007, Al Viro wrote:
> 
> BTW, this kind of situation happens often enough, so how about doing
> the following: teach kconfig that if FOO selects BAR and BAR depends
> on <expr>, we should act as if FOO had explicit depends on <expr>.

Sounds sane. I wonder if there are any non-obvious gotchas, and I worry 
that the indirect dependency ends up getting really confusing at times, 
but I don't think the notion is broken - just worrying about how to *show* 
this to explain what is going on when people say "why can't I select X".

		Linus
