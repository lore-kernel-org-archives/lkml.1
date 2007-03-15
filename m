Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbXCOR0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbXCOR0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXCOR0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:26:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50781 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbXCOR0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:26:32 -0400
Date: Thu, 15 Mar 2007 18:26:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070315172629.GA15026@one.firstfloor.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <1173879210.31159.30.camel@localhost.localdomain> <20070314134112.GB13486@elte.hu> <Pine.LNX.4.64.0703140945530.9690@woody.linux-foundation.org> <20070314181508.GB12994@elte.hu> <45F97971.7080000@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F97971.7080000@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You could do both. Have the x86 directory that Linus suggests for shared
> files, then have the build system generate the symlinks for you.

Symlinks are usually a bad idea because they tend to not work with objdirs. 
We did that in 2.4.

-Andi
