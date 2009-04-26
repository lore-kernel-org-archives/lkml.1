Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZDZDo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZDZDo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 23:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZDZDoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 23:44:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:53630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZDZDoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 23:44:19 -0400
Message-ID: <49F3D8CD.20007@kernel.org>
Date: Sun, 26 Apr 2009 12:45:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: unsik Kim <donari75@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mg_disk: fix CONFIG_LBD=y warning
References: <200904251503.23211.bzolnier@gmail.com>
In-Reply-To: <200904251503.23211.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 26 Apr 2009 03:44:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> drivers/block/mg_disk.c: In function ‘mg_dump_status’:
> drivers/block/mg_disk.c:265: warning: format ‘%ld’ expects type ‘long int’, but
> argument 2 has type ‘sector_t’
> 
> Cc: unsik Kim <donari75@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

FWIW-Acked-by: Tejun Heo <tj@kernel.org>

I think this should go through Jens' tree.  Care to cc Jens?

Thanks.

-- 
tejun
