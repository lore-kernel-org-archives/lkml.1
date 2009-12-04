Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZLDOWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZLDOWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbZLDOWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:22:45 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51481 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186AbZLDOWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:22:44 -0500
Date: Fri, 4 Dec 2009 15:22:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, zohar@us.ibm.com, jack@suse.cz, jmalicki@metacarta.com,
       dsmith@redhat.com, serue@us.ibm.com, hch@lst.de, john@johnmccutchan.com,
       rlove@rlove.org, ebiederm@xmission.com, heiko.carstens@de.ibm.com,
       penguin-kernel@I-love.SAKURA.ne.jp, mszeredi@suse.cz,
       akpm@linux-foundation.org, matthew@wil.cx, hugh.dickins@tiscali.co.uk,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       davem@davemloft.net, arnd@arndb.de, eric.dumazet@gmail.com
Subject: Re: [RFC PATCH 2/6] pipes: use alloc-file instead of duplicating
	code
Message-ID: <20091204142250.GF8742@kernel.dk>
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com> <20091203195902.8925.2985.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203195902.8925.2985.stgit@paris.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03 2009, Eric Paris wrote:
> The pipe code duplicates the functionality of alloc-file and init-file.  Use
> the generic vfs functions instead of duplicating code.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

