Return-Path: <linux-kernel-owner+w=401wt.eu-S1422896AbXBHAij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422896AbXBHAij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422877AbXBHAih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:38:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34453 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965712AbXBHAiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:38:15 -0500
Date: Thu, 8 Feb 2007 09:37:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       clameter@engr.sgi.com
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070208093740.70277c89.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070207094344.0efdde10.akpm@linux-foundation.org>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<p73ejp2mfqh.fsf@bingen.suse.de>
	<20070207082330.d07525ec.akpm@linux-foundation.org>
	<200702071750.55283.ak@suse.de>
	<20070207094344.0efdde10.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 09:43:44 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > > and to 
> > > accurately present the machine's topology to the user without us having to
> > > go adding falsehoods like this?
> > 
> > a node is a piece of memory. Without memory it doesn't make sense.
> 
> Who said?  I can pick up a piece of circuitry which has four CPUs and no
> RAM, wave it about then stick it in a computer.  The kernel is just wrong,
> surely?
> 
As far as I remember, this was the first e-mail which tells me that there are
- cpu only node
- device only node
- memory only node
during node-hot-plug discussion.

http://www.gelato.unsw.edu.au/archives/linux-ia64/0405/9679.html

Thanks,
-Kame

