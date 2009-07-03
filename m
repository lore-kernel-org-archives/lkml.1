Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZGCGtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZGCGtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZGCGtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:49:09 -0400
Received: from smtp.nokia.com ([192.100.105.134]:39054 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZGCGtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:49:08 -0400
Subject: Re: [PATCH] ubifs: allow more than one volume to be mounted
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-mtd@lists.infradead.org
In-Reply-To: <1246547747-13366-1-git-send-email-daniel@caiaq.de>
References: <1246547747-13366-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jul 2009 09:48:44 +0300
Message-Id: <1246603724.20721.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Jul 2009 06:48:45.0898 (UTC) FILETIME=[4FD28AA0:01C9FBAA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 17:15 +0200, Daniel Mack wrote:
> UBIFS uses a bdi device per volume, but does not care to hand out unique
> names to each of them. This causes an error when trying to mount more
> than one volumes.

I've simplified your patch a little and pushed to ubifs-2.6.git. Also
amended the MAINTAINERS file:

http://git.infradead.org/ubifs-2.6.git?a=commit;h=72093a661c0bd06d4843ac0ef8b909645483031b
http://git.infradead.org/ubifs-2.6.git?a=commit;h=42feebfc9af4ab505cacb0ea20bef35957ef2676

I'll send this fix to Linus in few days.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

