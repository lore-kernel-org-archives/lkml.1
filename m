Return-Path: <linux-kernel-owner+w=401wt.eu-S1761160AbXEKBFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160AbXEKBFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbXEKBFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:05:48 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37184 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714AbXEKBFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:05:47 -0400
Message-ID: <4643C071.608@zytor.com>
Date: Thu, 10 May 2007 18:01:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Ulrich Drepper <drepper@redhat.com>,
       Neil Brown <neilb@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <17969.22692.855242.359680@notabene.brown> <46315C61.30001@redhat.com> <464363DC.7060607@redhat.com> <20070510185226.GA1458@infradead.org>
In-Reply-To: <20070510185226.GA1458@infradead.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> 
> I'd be happy to have them.  While it's not the nicest API in the world
> it's in Posix and we have to support it at the library level, so we
> should better get it right.
> 
> I'd like to avoid having a big swithc statement in every filesystem,
> though, instead of we should have a table-driven approach instead
> where each filesystem defines one table (or multiple ones when it
> supports subtypes with different limits) and just sets a pointer in
> the superblock to it.
> 

This is starting to sound an awful lot like statfs().  Maybe we could
create a new statfs call which takes a buffer size input (so that we can
add new fields as time goes on) and which returns the necessary information?

	-hpa
