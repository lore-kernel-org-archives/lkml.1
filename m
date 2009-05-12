Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZELU1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZELU1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZELU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:27:42 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45935 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750832AbZELU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:27:41 -0400
Date: Tue, 12 May 2009 16:26:50 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: protect a fraction of file backed mapped
 pages from reclaim
In-Reply-To: <4A09D957.2070908@redhat.com>
Message-ID: <alpine.DEB.1.10.0905121623560.16057@qirst.com>
References: <20090508125859.210a2a25.akpm@linux-foundation.org> <20090512025246.GC7518@localhost> <20090512120002.D616.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905121650090.14226@qirst.com> <4A09AC91.4060506@redhat.com> <alpine.DEB.1.10.0905121718040.24066@qirst.com>
 <4A09B46D.9010705@redhat.com> <alpine.DEB.1.10.0905121801080.19973@qirst.com> <4A09D957.2070908@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Rik van Riel wrote:

> How many do you want before you're satisfied that this
> benefits a significant number of workloads?

One would be a good starter.

> How many numbers do you want to feel safe that no workloads
> suffer badly from this patch?
>
> Also, wow would you measure a concept as nebulous as desktop
> interactivity?

Measure the response to desktop clicks? I.e. retrieve an URL with a
webbrowser that was running when the other load started.

> Btw, the patch has gone into the Fedora kernel RPM to get
> a good amount of user testing.  I'll let you know what the
> users say (if anything).

I have not seen a single reference to a measurement taken with this patch.

Maybe that is because I have not looked at the threads that discuss
measurements with this patch. Where are they?
