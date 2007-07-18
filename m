Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbXGRMkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbXGRMkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 08:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXGRMj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 08:39:56 -0400
Received: from stinky.trash.net ([213.144.137.162]:37640 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbXGRMjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 08:39:55 -0400
Message-ID: <469E09FF.5050203@trash.net>
Date: Wed, 18 Jul 2007 14:39:27 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Denis Cheng <crquan@gmail.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net/core: some functions' definition order adjustment
 for readability
References: <20070718.030306.50591269.davem@davemloft.net> <1184758229305-git-send-email-crquan@gmail.com> <11847582511783-git-send-email-crquan@gmail.com>
In-Reply-To: <11847582511783-git-send-email-crquan@gmail.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This could be done in the patch moving it .. anyways,


Denis Cheng wrote:
> +#ifdef CONFIG_PROC_FS
> +static void *dev_mc_seq_start(struct seq_file *seq, loff_t *pos)


If you're interested in doing more work, it would be nice to
generalize the seq-file functions for unicast and multicast
address lists and add /proc/net/dev_unicast or something like
that.

OTOH we could also export this using rtnetlink. The main reason
why I didn't do that is that it can only be read, not changed,
but this is also true for statistics etc. Any opinions on this?

