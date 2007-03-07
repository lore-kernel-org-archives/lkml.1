Return-Path: <linux-kernel-owner+w=401wt.eu-S2992693AbXCGWru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992693AbXCGWru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992700AbXCGWru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:47:50 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:45888 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992693AbXCGWrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:47:49 -0500
Date: Wed, 7 Mar 2007 23:45:11 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Deepak Saxena <dsaxena@plexity.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building kernel under Solaris
In-Reply-To: <20070307094229.GG14863@infradead.org>
Message-ID: <Pine.LNX.4.61.0703072342310.2448@yvahk01.tjqt.qr>
References: <20070306180940.GA3240@plexity.net> <20070307094229.GG14863@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 7 2007 09:42, Christoph Hellwig wrote:
>>  #include <sys/time.h>
>>  #include <sys/ioctl.h>
>>  #include <sys/types.h>
>> +#ifndef __sun__
>>  #include <asm/types.h>
>>  #endif
>> +#endif
>
>So if solaris doesn't need it, why do we need it on Linux?

For __s32 and __s16.


Jan
-- 
