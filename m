Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYKCCsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYKCCsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 21:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYKCCrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 21:47:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:35123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbYKCCry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 21:47:54 -0500
Message-ID: <490E6648.4020503@kernel.org>
Date: Mon, 03 Nov 2008 11:47:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Joseph Chan <JosephChan@via.com.tw>,
       Jeff Garzik <jgarzik@redhat.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] sata_via: restore vt*_prepare_host error handling
References: <20081102211848.GA20785@joi>
In-Reply-To: <20081102211848.GA20785@joi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Nov 2008 02:47:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz wrote:
> commit b9d5b89b487517cbd4cb4702da829e07ef9e4432 (sata_via: fix support
> for 5287) accidently (?) removed vt*_prepare_host error handling - restore it
> 
> catched by gcc:
> drivers/ata/sata_via.c: In function 'svia_init_one':
> drivers/ata/sata_via.c:567: warning: 'host' may be used uninitialized in this function
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Joseph Chan <JosephChan@via.com.tw>
> Cc: Jeff Garzik <jgarzik@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
