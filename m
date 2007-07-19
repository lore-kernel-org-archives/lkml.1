Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXGSIp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXGSIp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936504AbXGSIov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:44:51 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57227 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935337AbXGSIou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:44:50 -0400
Date: Thu, 19 Jul 2007 12:44:12 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com
Subject: Re: [PATCH][RFC] network splice receive v3
Message-ID: <20070719084412.GD6216@2ka.mipt.ru>
References: <20070711091927.GQ4587@kernel.dk> <20070712170247.GA18469@2ka.mipt.ru> <20070713122058.GL5328@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070713122058.GL5328@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, Jul 13, 2007 at 02:21:00PM +0200, Jens Axboe (jens.axboe@oracle.com) wrote:
> > It really looks like the last tree we tested, so if you think additional
> > one will not hurt, feel free to ping, so I will completely rebase
> > testing tree.
> 
> It would be great if you could retest! There are some minor changes in
> there, and some extra testing definitely will not hurt.

I've just tested it with 2.6.22
(e1c1e98d2a3f57b22a0d4136c8160e54404aa437 commit) and did not found any
problems - after qute big files were transferred there is no observed 
previously skb leak, no crashes (quite a few debug options are turned on 
in config) and files are correct on both peers, so it works good.

> -- 
> Jens Axboe

-- 
	Evgeniy Polyakov
