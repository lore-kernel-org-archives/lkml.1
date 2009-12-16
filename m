Return-Path: <linux-kernel-owner+w=401wt.eu-S933825AbZLPNNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825AbZLPNNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZLPNNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:13:50 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37131 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbZLPNNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:13:49 -0500
Date: Wed, 16 Dec 2009 14:13:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cfq: Remove useless css reference get
Message-ID: <20091216131348.GR28252@kernel.dk>
References: <4B289C93.3070603@cn.fujitsu.com> <4e5e476b0912160309o100f538fo2462c8ac98dca844@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0912160309o100f538fo2462c8ac98dca844@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16 2009, Corrado Zoccolo wrote:
> Hi Gui,
> maybe you can add a comment that cfq_find_alloc_cfqg can now be called
> only under rcu_read_lock().

I'll add that while committing the patch.

-- 
Jens Axboe

