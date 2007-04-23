Return-Path: <linux-kernel-owner+w=401wt.eu-S1161209AbXDWSHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161209AbXDWSHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161205AbXDWSHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:07:20 -0400
Received: from ns1.suse.de ([195.135.220.2]:57909 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161209AbXDWSHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:07:18 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Hopper <hopper@omnifarious.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
References: <20070423020046.GA28477@omnifarious.org>
	<462C2E5B.1080008@redhat.com>
	<Pine.LNX.4.64.0704230353000.25153@server.thyself>
	<462C4858.3050006@redhat.com>
	<Pine.LNX.4.64.0704230555020.25153@server.thyself>
	<462C4D32.4000909@redhat.com>
	<Pine.LNX.4.64.0704230611430.25153@server.thyself>
	<462C5034.9090403@redhat.com>
	<Pine.LNX.4.64.0704230640540.25153@server.thyself>
	<20070423010445.454eda63.akpm@linux-foundation.org>
	<20070423135216.GA2744@omnifarious.org>
	<20070423104042.87b50bb3.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Apr 2007 21:05:13 +0200
In-Reply-To: <20070423104042.87b50bb3.akpm@linux-foundation.org>
Message-ID: <p731wia52ty.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> To get it unstuck we'd need a general push, get people looking at and testing
> the code, get the vendors to have a serious think about it, etc.  We could do
> that - it'd require that the namesys people (and I) start making threatening
> noises about merging it, I guess.

My impression was that a lot of negative discussion came out of some of the
user interface inventions in r4 (like sys_reiser4 and the
new incompatible EA interface). 

I guess a good strategy to get it going would be to extract just
a "core reiser4" out of it that is just a file system without
any new interfaces like this.

I would expect that reviewing that would be much smoother
because people could actually concentrate on the technical details.

-Andi
