Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbZCPMZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbZCPMZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758578AbZCPMZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:25:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52847 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145AbZCPMZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:25:19 -0400
Date: Mon, 16 Mar 2009 21:22:32 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Point the UNEVICTABLE_LRU config option at the documentation
Cc: kosaki.motohiro@jp.fujitsu.com, David Howells <dhowells@redhat.com>,
       lee.schermerhorn@hp.com, minchan.kim@gmail.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090316120224.GA16506@infradead.org>
References: <20090316105945.18131.82359.stgit@warthog.procyon.org.uk> <20090316120224.GA16506@infradead.org>
Message-Id: <20090316211830.1FE8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Mar 16, 2009 at 10:59:45AM +0000, David Howells wrote:
> > Point the UNEVICTABLE_LRU config option at the documentation describing the
> > option.
> 
> Didn't we decide a while ago that the option is pointless and the code
> should always be enabled?

Yeah.
CONFIG_UNEVICTABLE_LRU lost existing reason by David's good patch recently.

if nobody of nommu user post bug report in .30 age, I plan to remove
this config option at .31 age.

his patch is really really good job.



