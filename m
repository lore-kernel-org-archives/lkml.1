Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbZIWRSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbZIWRSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZIWRSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:18:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbZIWRSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:18:50 -0400
Date: Wed, 23 Sep 2009 10:18:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: change sys_truncate/sys_ftruncate length parameter
 type
In-Reply-To: <4ABA4D53.2040607@zytor.com>
Message-ID: <alpine.LFD.2.01.0909231015470.3303@localhost.localdomain>
References: <20090923150326.GB23595@osiris.boeblingen.de.ibm.com> <alpine.LFD.2.01.0909230808130.4950@localhost.localdomain> <4ABA4D53.2040607@zytor.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Sep 2009, H. Peter Anvin wrote:
> 
> I would argue that the current behavior is, if not incorrect (we define our
> own ABI after all) at least unwanted (we want our ABI to be as close as
> practical to the POSIX API.)

I think we care a WHOLE LOT more about binary compatibility than we care 
about some POSIX case for a braindamaged and fundamentally broken system 
call anyway.

The thing is, ftruncate() should take loff_t these days, so the old POSIX 
language is about a pointless system call where the _only_ thing that 
matters is legacy - and that legacy trumps any POSIX concerns.

			Linus
