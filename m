Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYIFOFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYIFOFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 10:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYIFOE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 10:04:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYIFOE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 10:04:58 -0400
Message-ID: <48C28DE7.8030302@zytor.com>
Date: Sat, 06 Sep 2008 07:04:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@newmail.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Ghost EDD devices in /sys again
References: <200809052219.44093.arvidjaar@newmail.ru> <200809061240.25925.arvidjaar@newmail.ru>
In-Reply-To: <200809061240.25925.arvidjaar@newmail.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> 
> Was it really that simple?
> 
> Subject: [PATCH] Fix ghost devices under /sys/firmware/edd
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> Some BIOSes do not always set CF on error before return from int13.
> The patch adds additional check for status being zero (AH == 0).
> 

Do you have any evidence that there aren't any BIOSes which leave AH != 
0 on legitimate success?  If so, you have turned a nuisance bug into 
something that could cause install failures.

	-hpa
