Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYDVIGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYDVIGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYDVIGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:06:04 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2921 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679AbYDVIGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:06:00 -0400
Date: Tue, 22 Apr 2008 09:05:47 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: False positive in checkpatch (2.6.25)
Message-ID: <20080422080547.GC26446@shadowen.org>
References: <Pine.LNX.4.44L0.0804171530070.19418-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0804171530070.19418-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 03:33:48PM -0400, Alan Stern wrote:

> ERROR: space prohibited after that '*' (ctx:ExW)
> #15: FILE: drivers/usb/core/driver.c:1544:
> +        * when the system suspend started, so we don't want to resume it
>          ^
> 
> ERROR: Missing Signed-off-by: line(s)

Yes, pretty sure that was triggered by a bug in comment tracking when
it moved into quote tracking.  From my testing here it should have been
fixed in v0.17, you have v0.16.  Andrew has the change queued up so it
should be on its way to mainline.  You can get the latest from the url
below to confirm:

	http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/

Thanks for the report.

-apw
