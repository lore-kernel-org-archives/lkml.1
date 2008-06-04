Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYFDDAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYFDDAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYFDDAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 23:00:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41083 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062AbYFDDAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 23:00:13 -0400
Date: Wed, 04 Jun 2008 12:00:09 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Subject: Re: [PATCH 1/4] per-task-delay-accounting: add memory reclaim delay
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
Message-Id: <20080604115917.9408.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> +	delayacct_freepages_start();
>  	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
> +	delayacct_freepages_end();

Shouldn't we consider memcgroup reclaim?



