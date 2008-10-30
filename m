Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYJ3R7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYJ3R7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYJ3R6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:58:53 -0400
Received: from lazybastard.de ([212.112.238.170]:45582 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYJ3R6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:58:53 -0400
Date: Thu, 30 Oct 2008 18:58:44 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081030175844.GC7157@logfs.org>
References: <20081026124643.GA1328@logfs.org> <20081030174300.GA1773@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081030174300.GA1773@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 October 2008 18:43:00 +0100, Pavel Machek wrote:
> 
> + * Disks have fulfilled the prerequite for a long time.  More recently DRAM
> 
> prerequisite?

In the paragraph above:

+ * B+Trees can be used similar to Linux radix trees (which don't have anything
+ * in common with textbook radix trees, beware).  Prerequisite for them working
+ * well is that access to a random tree node is much faster than a large number
+ * of operations within each node.

> +#define MAX(a, b) ((a) > (b) ? (a) : (b))
> 
> We already have that in the headers somewhere.

Except that min/max in include/linux/kernel.h have some type-safety
added.  In this particular case that is actually a disadvantage:
  CC      lib/btree.o
  lib/btree.c:56: error: braced-group within expression allowed only inside a function
  lib/btree.c:62: error: braced-group within expression allowed only inside a function
  lib/btree.c:67: error: braced-group within expression allowed only inside a function

So I need something more stupid. :)

Jörn

-- 
It does not require a majority to prevail, but rather an irate,
tireless minority keen to set brush fires in people's minds.
-- Samuel Adams
