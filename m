Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZAFV7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZAFV7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZAFV7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:59:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbZAFV7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:59:24 -0500
Date: Tue, 6 Jan 2009 13:59:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [PATCH 03/23] cris: introduce asm/swab.h
In-Reply-To: <1231277446.964.260.camel@brick>
Message-ID: <alpine.LFD.2.00.0901061357150.3057@localhost.localdomain>
References: <1231277446.964.260.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Harvey Harrison wrote:
>
> cris holds its arch overrides in an arch/ folder, rename these
> byteorder.h files to swab.h and include them from asm/swab.h
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/cris/include/arch-v10/arch/byteorder.h |   28 ---------------------------
>  arch/cris/include/arch-v10/arch/swab.h      |   28 +++++++++++++++++++++++++++
>  arch/cris/include/arch-v32/arch/byteorder.h |   22 ---------------------
>  arch/cris/include/arch-v32/arch/swab.h      |   22 +++++++++++++++++++++


Since you'e a git user, and you're basically renaming files while then 
putting a new name in place, can you please send patches done with both 
the "-M" flag (rename detection) _and_ the "-B" flag (which breaks 
associations of files even if the name stays the same)?

It's rare that this is needed, but it really helps. Now the patches look 
like a big delete/create event, and it's not at all obvious that the code 
is actually the same before and after.

		Linus
