Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYIBHHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYIBHHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 03:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYIBHHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 03:07:31 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33208 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYIBHHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 03:07:30 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <20080901150147.GA20323@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
	 <20080901150147.GA20323@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 02 Sep 2008 10:03:52 +0300
Message-Id: <1220339032.4036.31.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Sep 2008 07:07:18.0347 (UTC) FILETIME=[8950C9B0:01C90CCA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 11:01 -0400, Christoph Hellwig wrote:
> > For btrfs I xor the first 64 bits with the second 64 bits, and put
> > _that_ into f_fsid. You're just putting the first 64 bits in and
> > ignoring the second 64 bits. Neither is really _better_ than the other;
> > you just alter the circumstances in which you get collisions. But I
> > suppose we might as well be consistent about how we do it?
> 
> XFS just puts in the st_dev.  And I can't realy find any useful
> defintion of what it's supposed to b anyway..

For me this means that we should rather do what XFS does for
consistency then.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

