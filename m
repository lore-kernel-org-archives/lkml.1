Return-Path: <linux-kernel-owner+w=401wt.eu-S932609AbXHJVTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbXHJVTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbXHJVTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:19:24 -0400
Received: from palrel12.hp.com ([156.153.255.237]:53497 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXHJVTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:19:23 -0400
X-Greylist: delayed 1043 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 17:19:23 EDT
Message-ID: <46BCD223.6020304@hp.com>
Date: Fri, 10 Aug 2007 14:01:23 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Driver writer hints (was [PATCH 3/4] Add ETHTOOL_[GS]PFLAGS	sub-ioctls)
References: <20070810202426.GA25050@havoc.gtf.org>	<20070810202630.GB25095@havoc.gtf.org> <46BCCE57.1060802@garzik.org>
In-Reply-To: <46BCCE57.1060802@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If we are getting (retrieving) flags:
> 
>     3) Userland issues ETHTOOL_GPFLAGS, to obtain a 32-bit bitmap
> 
>     4) Userland prints out a tag returned from ETHTOOL_GSTRINGS
>        for each bit set to one in the bitmap.  If a bit is set,
>        but there is no string to describe it, that bit is ignored.
>        (i.e. a list of 5 strings is returned, but bit 24 is set)

Is that to enable "hidden" bits?  If not I'd think that emitting some 
sort of "UNKNOWN_FLAG" might help flush-out little oopses like 
forgetting a string.

rick jones

