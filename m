Return-Path: <linux-kernel-owner+w=401wt.eu-S935333AbYEBRS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935333AbYEBRS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760537AbYEBRSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:18:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059AbYEBRSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:18:05 -0400
Date: Fri, 2 May 2008 10:17:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
In-Reply-To: <20080502133234.GA24080@logfs.org>
Message-ID: <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org>
References: <20080502133234.GA24080@logfs.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 May 2008, Jörn Engel wrote:
> 
> not being familiar with either maintaining my own git tree or the -next
> process, I'd still like to get logfs into mainline.  It has gone through
> six rounds of reviews and the last has been mostly about crossing some
> i's here and dotting some t's there.

The thing I'd like to see is:

 - a more recent description of file system layout

   I've read the original paper, and I assume things have changed when 
   implementing stuff. They always do.

 - some benchmarks and/or comments about regular usage (ie fragmentation 
   etc). Yeah, it doesn't need to be all that extensive, but quite 
   frankly, it sounds like this is meant to be at least a partial 
   replacement for a GP filesystem (considering that seek/rotational 
   delay are going away) and people are working on it with USB memory 
   sticks etc, wouldn't it make sense to talk about disk usage (how much 
   the GC wants free etc) and everyday performance?

Hmm?

		Linus


