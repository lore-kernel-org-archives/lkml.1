Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbZAXQXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbZAXQXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 11:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZAXQXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 11:23:23 -0500
Received: from blu0-omc4-s10.blu0.hotmail.com ([65.55.111.149]:52217 "EHLO
	blu0-omc4-s10.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382AbZAXQXW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 11:23:22 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jan 2009 11:23:22 EST
Message-ID: <BLU122-W460604D42E2337F7CA32D4DACC0@phx.gbl>
X-Originating-IP: [84.216.37.216]
From: Peter Hallberg <hallberg68@hotmail.com>
To: <arjan@infradead.org>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: EXTRA_VERSION in #if LINUX_VERSION_CODE >= KERNEL_VERSION(x,x,x)
Date: Sat, 24 Jan 2009 17:17:09 +0100
Importance: Normal
In-Reply-To: <20090124080100.0843df1a@infradead.org>
References: <BLU122-W7F7E7A4757CD0F4C72C3BDACC0@phx.gbl>
 <20090124080100.0843df1a@infradead.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 Jan 2009 16:17:09.0246 (UTC) FILETIME=[34E879E0:01C97E3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> How does one write stuff like
>> #if LINUX_VERSION_CODE>= KERNEL_VERSION(2,6,28)
>> if the 4 digit EXTRA_VERSION also is needed?u
>
> if you need that something is wrong....
>
> can you be more elaborate in what you're trying to achieve ?

Between 2.6.28 and 2.6.28.1 you changed the function grab_cache_page to grab_cache_page_write_begin and added a flags argument. Since I maintain an separate filesystem module I need to take care of this.
>From the change log:
commit 4f093b80fa8facbd22fa36c00242e2fffa36e12f
Author: Nick Piggin 
Date:   Sun Jan 4 12:00:53 2009 -0800

    fs: symlink write_begin allocation context fix
    
    commit 54566b2c1594c2326a645a3551f9d989f7ba3c5e upstream.
Change grab_cache_page to
    accept a nofs argument as well, to honour that flag (while we're there,
    change the name to grab_cache_page_write_begin which is more instructive
    and does away with random leading underscores).


_________________________________________________________________
Hitta bästa priserna på MSN Shopping!
http://shopping.msn.se/co_16199-msn-shopping.html