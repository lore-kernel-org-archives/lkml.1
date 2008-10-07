Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYJGVH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYJGVH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYJGVHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:07:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56948
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753740AbYJGVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:07:09 -0400
Date: Tue, 07 Oct 2008 14:06:45 -0700 (PDT)
Message-Id: <20081007.140645.119998645.davem@davemloft.net>
To: npiggin@suse.de
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, paulmck@us.ibm.com
Subject: Re: [patch][rfc] ddds: "dynamic dynamic data structure" algorithm,
 for adaptive dcache hash table sizing (resend)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081007075309.GA16143@wotan.suse.de>
References: <20081007070225.GB5959@wotan.suse.de>
	<20081007071827.GB5010@infradead.org>
	<20081007075309.GA16143@wotan.suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Tue, 7 Oct 2008 09:53:09 +0200

> Dcache lookup is partially a tree lookup, but also how do you look up
> entries in a given directory? That is not naturally a tree lookup. Could
> be a per directory tree, though, or a hash, or trie.
> 
> Anyway, I don't volunteer to change that just yet ;)

Historically speaking, the original dcache by Thomas Schoebel-Theuer
(circa 1997) was in fact implemented as a per-directory hash table.

This has all kinds of recursion and other issues, which is why Linus
eventually changed it to use a global hash table scheme.
