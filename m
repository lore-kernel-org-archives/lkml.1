Return-Path: <linux-kernel-owner+w=401wt.eu-S1762712AbXGaWe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762712AbXGaWe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbXGaWeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:34:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755967AbXGaWeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:34:21 -0400
Date: Tue, 31 Jul 2007 15:34:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Joe Jin <joe.jin@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
Subject: Re: [PATCH] add check do_direct_IO() return val
Message-Id: <20070731153410.fcbf9a1b.akpm@linux-foundation.org>
In-Reply-To: <1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com>
References: <20070727071547.GA25084@joejin-pc.cn.oracle.com>
	<46A9E6F9.20603@oracle.com>
	<20070728034719.GA24448@joejin-pc.cn.oracle.com>
	<20070730135316.2ce21b28.akpm@linux-foundation.org>
	<1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com>
	<6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com>
	<1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com>
	<05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com>
	<20070731005348.GA8308@joejin-pc.cn.oracle.com>
	<46AEB055.9050607@us.ibm.com>
	<20070731043554.GA3393@joejin-pc.cn.oracle.com>
	<1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 15:25:11 -0700
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> +	dio->map_bh.b_state = 0;

ho hum, thanks.

We zero out so many fields in there now that a kzalloc() might yield
a net gain.  0.000001% in an unnamed benchmark!
