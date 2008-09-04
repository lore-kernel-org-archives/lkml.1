Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYIDAhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYIDAhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYIDAhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:37:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:34693 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbYIDAhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:37:07 -0400
Message-ID: <48BF2D4E.4090906@kernel.org>
Date: Thu, 04 Sep 2008 02:35:26 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org> <48BEB759.4050503@zytor.com> <48BEB98C.8030303@kernel.org> <48BEBAF0.7070008@zytor.com> <48BEBF34.50006@kernel.org> <48BED351.1060300@zytor.com> <48BF2AEB.1050508@kernel.org> <48BF2BAC.9070508@zytor.com>
In-Reply-To: <48BF2BAC.9070508@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Sep 2008 00:36:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Note that addition /partitions/ is somewhat unlikely to be useful, since
> existing code will have to search through random crap in sysfs to look
> for the partition directories anyway.

Currently it has to list /sys/block/DEV/DEV[-]N/.  With proper
classification, it can do /sys/block/*/partitions/*.  We'll need to keep
around symlinks at the root level.  It also plays well with how other
subsystems have been changing.

-- 
tejun
