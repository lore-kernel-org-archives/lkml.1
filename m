Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbYLHJyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbYLHJyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYLHJym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:54:42 -0500
Received: from smtp.nokia.com ([192.100.122.233]:21111 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYLHJym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:54:42 -0500
Subject: Re: UBI/DVB ioctl conflict?
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: linux-mtd@lists.infradead.org, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       v4l-dvb-maintainer@linuxtv.org, LKML <linux-kernel@vger.kernel.org>,
       arnd@arndb.de
In-Reply-To: <200812081041.14178.laurentp@cse-semaphore.com>
References: <20081207095811.13b51cca@zod.rchland.ibm.com>
	 <1228717226.13686.89.camel@sauron>
	 <200812081041.14178.laurentp@cse-semaphore.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 08 Dec 2008 11:51:55 +0200
Message-Id: <1228729915.13686.95.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 08 Dec 2008 09:53:55.0582 (UTC) FILETIME=[E23389E0:01C9591A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-08 at 10:41 +0100, Laurent Pinchart wrote:
> Correct me if I'm wrong, but doesn't this only matters for devices that would 
> implement both the UBI and DVB API on the same inode ? That would be quite 
> unlikely.

Yeah, I guess. But this anyway makes sense to keep ioctls
non-overlapping.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

