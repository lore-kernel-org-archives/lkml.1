Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYEORyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYEORyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYEORyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:54:00 -0400
Received: from webhosting.zipcon.net ([209.221.136.93]:60227 "EHLO
	webhosting.zipcon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYEORx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:53:59 -0400
X-Greylist: delayed 3763 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2008 13:53:59 EDT
Message-ID: <482C6A02.2030600@beezmo.com>
Date: Thu, 15 May 2008 09:51:14 -0700
From: William D Waddington <william.waddington@beezmo.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFCLUE4] scatterlist changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - webhosting.zipcon.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - beezmo.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have just tripped over the scatterlist changes in my out-of-tree
drivers.  I'll deal with it.  When the API stabilizes...

It does bring to mind a simple question:  why limit the scatterlist
to a single page, or require a multiple-page list to be dealt with
as individual pages?

Is this just to avoid vmalloc use?  I don't see anything that requires
a scatterlist to be in physically contiguous memory (at a quick glance
anyway) other than perhaps a preference for the initial allocation
mechanism.  (My actual IOPB list for the DMA hardware is a different
matter entirely, but I don't _think_ I'm confusing the two).

Thanks,
Bill
-- 
--------------------------------------------
William D Waddington
Bainbridge Island, WA, USA
william.waddington@beezmo.com
--------------------------------------------
"Even bugs...are unexpected signposts on
the long road of creativity..." - Ken Burtch
