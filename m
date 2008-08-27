Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYH0GrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYH0GrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYH0GrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:47:06 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40262 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbYH0GrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:47:05 -0400
Subject: RE: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Tim Anderson <tanderson@mvista.com>
Cc: Bruce_Leonard@selinc.com, "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-mtd-bounces@lists.infradead.org,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       "'Bruce Leonard'" <brucle@earthlink.net>
In-Reply-To: <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
References: <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 27 Aug 2008 09:38:29 +0300
Message-Id: <1219819109.18027.154.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Aug 2008 06:41:33.0751 (UTC) FILETIME=[F22FA470:01C9080F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 23:20 -0700, Tim Anderson wrote:
> Artem,
> 
> I see your point. Ioctls are going away after all.
> 
> So we should have something like:
> /sys/class/mtd/mtd0/
> 
> Or just under device or platform? 

I am not very good in LDM, but it does not look like MTD stuff should go
to /sys/class/. I'd say it should be in /sys/devices/.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

