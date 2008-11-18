Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYKROGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYKROGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYKROGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:06:38 -0500
Received: from smtp.nokia.com ([192.100.105.134]:56911 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbYKROGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:06:37 -0500
Subject: Re: [PATCH] physmap: Fix leak of memory returned by
	parse_mtd_partitions
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1227016647.27728.398.camel@macbook.infradead.org>
References: <20081112.235733.01917391.anemo@mba.ocn.ne.jp>
	 <20081113.005534.56563769.anemo@mba.ocn.ne.jp>
	 <8bd0f97a0811120808p5858d5adleeef43b1d374bee1@mail.gmail.com>
	 <1227016647.27728.398.camel@macbook.infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 18 Nov 2008 16:04:38 +0200
Message-Id: <1227017078.16925.123.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Nov 2008 14:06:26.0087 (UTC) FILETIME=[D8582370:01C94986]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-18 at 13:57 +0000, David Woodhouse wrote:
> I suspect it might be better to take the simple bug-fix approach for
> now, given that we are planning a revamp of the MTD core API anyway --
> we can redo partitions properly at the point, so they aren't just an
> evil hack.

Off topic: is this going to really happen? Are you have real plans
to do this?

Also, you also mentioned that you have sysfs for MTD, are we going to
see them in mtd-2.6.git any time soon?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

