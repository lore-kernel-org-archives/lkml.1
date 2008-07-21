Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbYGUDUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbYGUDUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbYGUDUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:20:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:43874 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758832AbYGUDUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:20:21 -0400
Subject: Re: [PATCH] elf loader support for auxvec base platform string
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       Nathan Lynch <ntl@pobox.com>
In-Reply-To: <alpine.LFD.1.10.0807170908060.2959@woody.linux-foundation.org>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
	 <1216166331-14810-2-git-send-email-ntl@pobox.com>
	 <1216276539.7740.309.camel@pasglop>
	 <alpine.LFD.1.10.0807170908060.2959@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 13:19:48 +1000
Message-Id: <1216610388.11027.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 09:10 -0700, Linus Torvalds wrote:
> 
> On Thu, 17 Jul 2008, Benjamin Herrenschmidt wrote:
> > 
> > Should I seek somebody's ack before merging a patch like the one below ?
> > 
> > I'm a bit reluctant to merge via the powerpc.git tree some changes to
> > generic files without at least an ack from somebody else :-)
> 
> Gaah. Generally we don't, but you're right to ask. The ELF loading keeps 
> on accumulating these things, and I'm not sure we have the right process 
> for things like this. They're all individually small and insignificant, 
> and they are all individually never going away and making the ELF loader 
> messier and messier.

Yeah, annoying. Oh well, this one at least is now getting Andrew's
scrutinity...

Cheers,
Ben.


