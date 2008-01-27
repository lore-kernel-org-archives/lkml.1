Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYA0GCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYA0GCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYA0GBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:01:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066AbYA0GBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:01:46 -0500
Date: Sat, 26 Jan 2008 22:01:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MEMSTICK] Updates for the memstick driver
Message-Id: <20080126220147.c9be389e.akpm@linux-foundation.org>
In-Reply-To: <439089.5370.qm@web36701.mail.mud.yahoo.com>
References: <20080122105900.c7ea1cc3.akpm@linux-foundation.org>
	<439089.5370.qm@web36701.mail.mud.yahoo.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Jan 2008 23:58:52 -0800 (PST) Alex Dubov <oakad@yahoo.com> wrote:
> * Mark shared inline functions as static
> 
> * Use member-at-a-time assignment for protocol structures
> 
> * Comments for publicly exported functions
> 
> * Use end_queued_request to end unhandled block layer requests
> 
> * Use sysfs attribute group to export MSPro attributes
> 
> * Fix includes
> 
> * Use scnprintf instead of snprintf where string length matters
> 
> * Remove spurious get_device/put_device in probe method
> 

Please sign off your patches.

Please don't send wordwrapped patches.

Please put the subsystem identifier "memstick" outside [], for reasons
described in http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

Your patch contained a fix which I already merged into -mm, which suggests
that you haven't been testing the code in 2.6.24-rc8-mm1.  Please do test
-mm when you have patches in there, so that we know that we'll be merging
things which work.

Thanks.
