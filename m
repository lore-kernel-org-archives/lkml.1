Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbYGQQMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbYGQQMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbYGQQLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:11:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109AbYGQQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:11:45 -0400
Date: Thu, 17 Jul 2008 09:10:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       Nathan Lynch <ntl@pobox.com>
Subject: Re: [PATCH] elf loader support for auxvec base platform string
In-Reply-To: <1216276539.7740.309.camel@pasglop>
Message-ID: <alpine.LFD.1.10.0807170908060.2959@woody.linux-foundation.org>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>  <1216166331-14810-2-git-send-email-ntl@pobox.com> <1216276539.7740.309.camel@pasglop>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Benjamin Herrenschmidt wrote:
> 
> Should I seek somebody's ack before merging a patch like the one below ?
> 
> I'm a bit reluctant to merge via the powerpc.git tree some changes to
> generic files without at least an ack from somebody else :-)

Gaah. Generally we don't, but you're right to ask. The ELF loading keeps 
on accumulating these things, and I'm not sure we have the right process 
for things like this. They're all individually small and insignificant, 
and they are all individually never going away and making the ELF loader 
messier and messier.

I dunno. 

		Linus
