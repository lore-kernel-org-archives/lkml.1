Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZAEQjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZAEQjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZAEQj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:39:26 -0500
Received: from postel.suug.ch ([194.88.212.233]:53371 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbZAEQjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:39:25 -0500
Date: Mon, 5 Jan 2009 17:10:58 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] cls_cgroup: fix an oops when removing a cgroup
Message-ID: <20090105161058.GM20815@postel.suug.ch>
References: <49584A9F.40202@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49584A9F.40202@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> 2008-12-29 11:57
> When removing a cgroup, an oops was triggered immediately. The cause
> is wrong kfree() in cgrp_destroy().

Good catch.

Acked-by: Thomas Graf <tgraf@suug.ch>
