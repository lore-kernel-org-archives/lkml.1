Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbYDUL6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbYDUL6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbYDUL6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:58:40 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45064 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbYDUL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:58:39 -0400
Date: Mon, 21 Apr 2008 13:13:38 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andi Kleen <andi@firstfloor.org>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, menage@google.com,
       xemul@openvz.org, shiwh@cn.fujitsu.com, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
In-Reply-To: <480C7D4C.1070502@firstfloor.org>
Message-ID: <Pine.LNX.4.64.0804211301500.20183@blonde.site>
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0804210004470.1630@blonde.site>
 <20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com>
 <20080420232427.1b399104.akpm@linux-foundation.org> <480C347C.6060702@linux.vnet.ibm.com>
 <20080421064725.GA32214@balbir.in.ibm.com> <Pine.LNX.4.64.0804211158001.10521@blonde.site>
 <480C7D4C.1070502@firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008, Andi Kleen wrote:
> Hugh Dickins wrote:
> > On Mon, 21 Apr 2008, Balbir Singh wrote:
> > I've added Andi to the Cc's, I don't want to sneak away something
> > he's expecting there.  If 2.6.25 had gone out with a convention that
> > controller infrastructure gets compiled in, but has then to be enabled
> > at boottime or runtime, okay; 
> 
> That is what I have been expecting yes.
> 
> If later the slow down is fixed it can be also enabled by default too.

It is disabled by default, in the config; and Paul/Balbir already
provided the cgroup_disable=memory bootoption to override that.

Is it wise to add an additional hurdle now that 2.6.25 has gone out?
Is it wise to switch it around in future?  Seems a source of confusion
to me (I already wasted time testing the same things twice in -mm
because of this).

I guess Andrew needs to make an executive decision!
Whichever way round, we ought to clarify the config helptext.

Hugh
