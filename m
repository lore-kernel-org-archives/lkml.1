Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZLCWAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZLCWAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZLCWAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:00:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38663
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbZLCWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:00:40 -0500
Date: Thu, 03 Dec 2009 14:00:45 -0800 (PST)
Message-Id: <20091203.140045.67902314.davem@davemloft.net>
To: eparis@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, zohar@us.ibm.com, jack@suse.cz, jmalicki@metacarta.com,
       dsmith@redhat.com, serue@us.ibm.com, hch@lst.de, john@johnmccutchan.com,
       rlove@rlove.org, ebiederm@xmission.com, heiko.carstens@de.ibm.com,
       penguin-kernel@I-love.SAKURA.ne.jp, mszeredi@suse.cz,
       jens.axboe@oracle.com, akpm@linux-foundation.org, matthew@wil.cx,
       hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com,
       nishimura@mxp.nes.nec.co.jp, arnd@arndb.de, eric.dumazet@gmail.com
Subject: Re: [RFC PATCH 4/6] networking: rework socket to fd mapping using
 alloc-file
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091203195917.8925.84203.stgit@paris.rdu.redhat.com>
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com>
	<20091203195917.8925.84203.stgit@paris.rdu.redhat.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>
Date: Thu, 03 Dec 2009 14:59:17 -0500

> Currently the networking code does interesting things allocating its struct
> file and file descriptors.  This patch attempts to unify all of that and
> simplify the error paths.  It is also a part of my patch series trying to get
> rid of init-file and get-empty_filp and friends.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

I'm fine with this:

Acked-by: David S. Miller <davem@davemloft.net>
