Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZDTGro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZDTGro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZDTGre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:47:34 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41530 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZDTGre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:47:34 -0400
Subject: Re: [PATCH 2/4] [MTD] Add MEMERASE64 ioctl for >4GiB devices
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux MTD <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <a95a62fe0904180921w3ac0128et7a543742f5734d64@mail.gmail.com>
References: <a95a62fe0904082252h41afa872j2ef6fb9d1d76dc27@mail.gmail.com>
	 <1239953416.3390.243.camel@localhost.localdomain>
	 <a95a62fe0904180921w3ac0128et7a543742f5734d64@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Apr 2009 09:47:11 +0300
Message-Id: <1240210031.14298.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Apr 2009 06:47:13.0396 (UTC) FILETIME=[D61E5B40:01C9C183]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-18 at 09:21 -0700, Kevin Cernekee wrote:
> On Fri, Apr 17, 2009 at 12:30 AM, Artem Bityutskiy
> <dedekind@infradead.org> wrote:
> > Kevin, are you going to re-send patches 2-4, taking into account
> > Arnd's and Andrew's suggestions?
> 
> For Arnd's suggestion, I posted a followup patch here:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2009-April/025269.html
> 
> Andrew brought up two issues: [MTD] in the subject line, and
> linewrapping.  I am assuming that he fixed these himself since he
> pulled all five patches (originals + followup) into the -mm tree.
> 
> Should I fix and repost the set anyway?

No, I just missed that patch. Pushed your patches to l2-mtd-2.6.git.
Will ping dwmw2 about this. I also checked that your patches at
least do not break MTD for UBI/UBIFS. Thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

