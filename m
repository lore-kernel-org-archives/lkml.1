Return-Path: <linux-kernel-owner+w=401wt.eu-S1763424AbYDUQ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763424AbYDUQ2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbYDUQ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:28:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64917 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYDUQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:28:09 -0400
Date: Mon, 21 Apr 2008 09:26:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [bug] build failures, git trees
Message-Id: <20080421092648.943a871b.randy.dunlap@oracle.com>
In-Reply-To: <20080421.015837.35795810.davem@davemloft.net>
References: <20080419103942.GA13599@elte.hu>
	<20080419.040945.13369499.davem@davemloft.net>
	<20080421082254.GA2522@elte.hu>
	<20080421.015837.35795810.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 01:58:37 -0700 (PDT) David Miller wrote:

<deletia>

> If you really cared, you would run your randconfig system on, for
> example, the linux-next and -mm trees, which I've specifically
> suggested and you've specifically ignored.  And there is no
> coincidence to that.

I do randconfigs on -mm and linux-next.  I report most* of the
build problems ... and as far as I can tell, they are mostly
ignored (especially in linux-next).

*: I don't report Voyager/Visual WS/NUMA-Q build errors.
Maybe they will just disappear one day.
I also don't report drivers/media/ build errors. They are too easy
to reproduce.  :(

IMO having -mm and linux-next is a diluting factor+.  They dilute
both build and boot testing of the other one and of mainline
-rcs.  Yes, they have their purposes, but it would be Very Good
if we could get to the point of having -mm built on top of
linux-next (e.g.) instead of it just being a separate tree.

+: Yes, there are other diluting factors, like having over 100 git
trees that someone may potentially request testing of.

---
~Randy
