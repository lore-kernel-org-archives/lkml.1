Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbXEaNrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbXEaNrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXEaNrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:47:14 -0400
Received: from brick.kernel.dk ([80.160.20.94]:1425 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbXEaNrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:47:13 -0400
Date: Thu, 31 May 2007 15:46:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Anand Jahagirdar <anandjigar@gmail.com>
Cc: security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Patch related with Fork Bombing Atack
Message-ID: <20070531134611.GZ32105@kernel.dk>
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31 2007, Anand Jahagirdar wrote:
> 2) Printk message in my patch will definitely help Administrator/Root
> User to detect which particular user is trying fork bombing attack on
> his machine by looking at /var/log/messages or dmesg . he can take
> action against that particular user and kill his processes.

You just opened a DoS possibility for any user, they can now flood the
syslog instead.

-- 
Jens Axboe

