Return-Path: <linux-kernel-owner+w=401wt.eu-S1763884AbZBZAHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763884AbZBZAHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZBZAHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:07:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56368 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZBZAHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:07:37 -0500
Message-ID: <49A5DC77.2060009@zytor.com>
Date: Wed, 25 Feb 2009 16:04:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] Make exported headers use strict posix types
References: <20090225032553.GD6690@bombadil.infradead.org> <20090225201131.GA26110@uranus.ravnborg.org> <49A5CF2E.6050306@zytor.com> <200902260101.31580.arnd@arndb.de>
In-Reply-To: <200902260101.31580.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> Just in the minute I notice a bug :(
> 
> Unfortunately, I mistakenly replaced uid_t with __kernel_uid_t when
> it had to be __kernel_uid32_t. New series follows, including the
> changes for all integer types.
> 

S'okay... it's easy enough to back out at this time.

	-hpa

