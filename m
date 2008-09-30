Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYI3JDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYI3JDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYI3JDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:03:14 -0400
Received: from smtp.nokia.com ([192.100.122.233]:51376 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYI3JDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:03:13 -0400
Subject: Re: What is in ubifs-2.6.git
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Amit Kumar Sharma <amitsharma.9@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <EC8994007A40495FA924271106803A63@sisodomain.com>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
	 <EC8994007A40495FA924271106803A63@sisodomain.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 30 Sep 2008 12:02:43 +0300
Message-Id: <1222765363.8051.10.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 30 Sep 2008 09:02:56.0522 (UTC) FILETIME=[545B46A0:01C922DB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-30 at 14:25 +0530, Amit Kumar Sharma wrote:
> Hi Artem
> 
> OneNAND can support for full block read also in sync burst 
> block read mode ,so why u want to limit bulk read only for 4 
> pages , with sync burst enable u can read max 64 pages.
> so in place of max 4 pages , u can set max to 64 it will be 
> improve performance if sync burst mode is upported.

Actually UBIFS reads up to whole eraseblock. So if you have
a file, and it is resided in consecutive NAND pages of an
eraseblock, and UBIFS has decided to do read-ahead, it would
read whole eraseblock. So for OneNAND, indeed UBIFS may read
up to 64 NAND pages at one go.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

