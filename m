Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbYEPTRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbYEPTRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYEPTRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:17:35 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33415 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751715AbYEPTRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:17:34 -0400
Date: Fri, 16 May 2008 12:17:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <20080515201413.GT9921@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805161214160.3533@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
 <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
 <20080515174953.GN9921@parisc-linux.org> <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com>
 <20080515181356.GP9921@parisc-linux.org> <Pine.LNX.4.64.0805151141510.19915@schroedinger.engr.sgi.com>
 <20080515185130.GR9921@parisc-linux.org> <Pine.LNX.4.64.0805151153440.20201@schroedinger.engr.sgi.com>
 <20080515192959.GS9921@parisc-linux.org> <20080515201413.GT9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Matthew Wilcox wrote:

> > No doubt you prefer to run a test which fails to show a problem with
> > your code.  How about you try running a test which does show a problem?
> 
> This is rather interesting.  Since Christoph refuses to, here's my
> results with 8f40f67, first with slab:

I sure wish you would follow the discussions instead of having paranoid 
thoughts about me not running tests that show regressions. See my 
extensive test suite that shows the worst cases in my vm git tree.

> I think I'm going to try backing out some of the recent patches that
> have gone into /slab/ and see if it's been regressing.

Hmmm... Interesting. Could you post the output of slabinfo -AD?
