Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZLKO1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZLKO1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbZLKO1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:27:38 -0500
Received: from snt0-omc3-s1.snt0.hotmail.com ([65.55.90.140]:15444 "EHLO
	snt0-omc3-s1.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754874AbZLKO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:27:38 -0500
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS18FDA82A2FB992AC38B693A78C0@phx.gbl>
From: "Ioannis Kyriakopoulos" <johnkyr83@hotmail.com>
To: "'Christoph Lameter'" <cl@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
References: <SNT111-DS372EC73016B4FB39E0ACAA78C0@phx.gbl> <alpine.DEB.2.00.0912110802250.32415@router.home>
In-Reply-To: <alpine.DEB.2.00.0912110802250.32415@router.home>
Subject: RE: Finding and chaniging registered clocksources
Date: Fri, 11 Dec 2009 14:27:42 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acp6ayjqKmfB3hKjQS2tgYkTN3q7XAAAK2CQ
Content-Language: en-gb
X-OriginalArrivalTime: 11 Dec 2009 14:27:45.0062 (UTC) FILETIME=[1AF33C60:01CA7A6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks very much for the reply.

>> However, I don't know how to found out what clocksource Linux has
assigned
>> for other activities apart from the one mentioned (e.g. for timekeeping)
and
>> how to change it, if possible.
>
>Depends on the subsystem.

Could you be a little more specific please cause I don't understand?

>getnstimeofday uses the syste, cllock that can be retrieved using
>/sys/devices/system/clocksource/clocksource0/current_clocksource

The problem in my case is that when I execute the above, I get:
cat: can't open
'/sys/devices/system/clocksource/clocksource0/current_clocksource': No such
file or directory
In general, my /sys directory is empty. This file should exist to my
filesystem prior to kernel execution or should it be created by the kernel
when it starts executing; but for some reason it is not being created in my
case?

Thanks.

