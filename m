Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYH0GMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYH0GMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbYH0GMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:12:06 -0400
Received: from smtp.nokia.com ([192.100.105.134]:36663 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYH0GME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:12:04 -0400
Subject: RE: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Tim Anderson <tanderson@mvista.com>
Cc: Bruce_Leonard@selinc.com, "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-mtd-bounces@lists.infradead.org,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       "'Bruce Leonard'" <brucle@earthlink.net>
In-Reply-To: <000101c9080a$4ec3a6b0$6b01a8c0@mvista.com>
References: <000101c9080a$4ec3a6b0$6b01a8c0@mvista.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 27 Aug 2008 09:03:37 +0300
Message-Id: <1219817017.18027.149.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Aug 2008 06:06:41.0528 (UTC) FILETIME=[131FBF80:01C9080B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 23:01 -0700, Tim Anderson wrote:
> I have been experimenting with this. I think there is at least 3 maybe 4
> IOCTLS that are going to need to have a LARGE mode. The 2 most obvious are
> MEMGETINFO and MEMERASE.

dwmw2 vetoed any MEMGETINFO ioctl changes, or new similar ioctls, and it
kind of make sense, because we should use sysfs instead. But this, in
turn, means implementing sysfs support for MTD, because MTD is not
LinuxDeviceModel-enabled at the moment.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

