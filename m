Return-Path: <linux-kernel-owner+w=401wt.eu-S937733AbXGSJAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937733AbXGSJAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933269AbXGSI7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:59:50 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:60009 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763849AbXGSI7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:59:49 -0400
Date: Thu, 19 Jul 2007 09:19:10 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: cmpxchg is not available to generic code
In-Reply-To: <20070719011055.1392c7d2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707190917330.21859@skynet.skynet.ie>
References: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707190900320.19586@skynet.skynet.ie>
 <20070719011055.1392c7d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>
>> they need to grow a userpsace
>> cmpxchg as davem mentioned to go along with this, changing the drm now
>> isn't possible due to backwards compat..
>
> For reference purposes, that position is not acceptable.  We _never_ accept the
> "oh I can't change my proposed kernel interface because I already have
> userspace relying on it" argument.

Yes it is, I thought breaking userspace API was the worst crime in kernel 
history, (unless you are sysfs...) the userspace DRM has been around since 
2.2 days at least, so there are lots of legacy userspaces to break..

> Hopefully that won't be an issue here.  I guess DRM now needs a
> `depends on !ARM'.

Possibly the answer..

Dave.

-- 
David Airlie, Software Engineer
http://www.skynet.ie/~airlied / airlied at skynet.ie
Linux kernel - DRI, VAX / pam_smb / ILUG

