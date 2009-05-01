Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbZEAMA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbZEAMA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbZEAMAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:00:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:59694 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbZEAMAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:00:13 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0905011235060.8513@blonde.anvils>
References: <1241097822.2516.3.camel@poy> <Pine.LNX.4.64.0905011235060.8513@blonde.anvils>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 May 2009 13:59:52 +0200
Message-ID: <ac3eb2510905010459l716b2175y33799a93b6e8a730@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 13:41, Hugh Dickins <hugh@veritas.com> wrote:
> I've no opinion on the big picture of your devtmpfs proposal.
> But note that there's a second, !CONFIG_SHMEM, version of init_tmpfs()
> also in mm/shmem.c - you'll want to take the "static " off that too,
> for the tiny embedded case when ramfs is used to serve up tmpfs.

Ah, I see. Done. Will be in the next update.

Thanks a lot,
Kay
