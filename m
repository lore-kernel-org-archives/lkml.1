Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbZLJBmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbZLJBmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759375AbZLJBmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:42:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46043 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759373AbZLJBmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:42:09 -0500
Date: Thu, 10 Dec 2009 02:42:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paul Menage <menage@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, kosaki.motohiro@jp.fujitsu.com,
       hugh.dickins@tiscali.co.uk, nishimura@mxp.nes.nec.co.jp,
       balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, npiggin@suse.de, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [23/31] HWPOISON: add memory cgroup filter
Message-ID: <20091210014212.GI18989@one.firstfloor.org>
References: <200912081016.198135742@firstfloor.org> <20091208211639.8499FB151F@basil.firstfloor.org> <6599ad830912091247v1270a86er45ea8ceeff28e727@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830912091247v1270a86er45ea8ceeff28e727@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While the functionality sounds useful, the interface (passing an inode
> number) feels a bit ugly to me. Also, if that group is deleted and a
> new cgroup created, you could end up reusing the inode number.

Please note this is just a testing interface, doesn't need to be
100% fool-proof. It'll never be used in production.

> 
> How about an approach where you write either the cgroup path (relative
> to the memcg mount) or an fd open on the desired cgroup? Then you
> could store a (counted) css reference rather than an inode number,
> which would make the filter function cleaner too, since it would just
> need to compare css objects.

Sounds complicated, I assume it would be much more code?
I would prefer to keep the testing interfaces as simple as possible.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
