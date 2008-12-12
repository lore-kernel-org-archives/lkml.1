Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYLLQCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYLLQCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbYLLQCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:02:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43506 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280AbYLLQCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:02:21 -0500
Message-ID: <49428AFD.5090009@redhat.com>
Date: Fri, 12 Dec 2008 17:02:05 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <20081212152929.GM26095@parisc-linux.org> <494287D4.2070909@redhat.com> <20081212155113.GO26095@parisc-linux.org>
In-Reply-To: <20081212155113.GO26095@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On the other hand, NetBSD have approximately 0% market share.
> We shouldn't let them lock us into making a bad decision.  Is there
> anyone other than NetBSD who has added these syscalls?

Free- and OpenBSD have it too.  For Solaris I've found a feature request
only.  Dunno about MacOS/Darwin.  Other un*xes which are important these
days?

I'd *really* hate it to have the same system call with different
argument ordering on different systems though.  Especially when swapping
two integer values, so gcc wouldn't error out on wrong usage.

cheers,
  Gerd
