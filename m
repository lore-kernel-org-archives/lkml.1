Return-Path: <linux-kernel-owner+w=401wt.eu-S1030477AbXDKXZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030477AbXDKXZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030528AbXDKXZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:25:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36005 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030477AbXDKXZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:25:07 -0400
Date: Wed, 11 Apr 2007 16:25:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Hafting <helgehaf@aitel.hist.no>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-Id: <20070411162501.97635f35.akpm@linux-foundation.org>
In-Reply-To: <20070411230700.GA4023@aitel.hist.no>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
	<20070411194227.GA31286@aitel.hist.no>
	<20070411134346.d10765da.akpm@linux-foundation.org>
	<20070411230700.GA4023@aitel.hist.no>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 01:07:00 +0200
Helge Hafting <helgehaf@aitel.hist.no> wrote:

> On Wed, Apr 11, 2007 at 01:43:46PM -0700, Andrew Morton wrote:
> > 
> > OK.  If you add initcall_debug to the kernel boot command line, what's the
> > last thing we call?
> 
> The last messages (handwritten, somewhat shortened)
> calling hid_init+0x0/0x10()
> returned 0
> ran for 0 msec
> calling hid_init+0x0/0x50()
> usbcore registered new interface driver hiddev
> 
> and then it hangs completely.
> 

OK, thanks.  If it happens to be, I'll bisect it down.  Chances are it
won't, and it gets merged, and we get to futz around with it for a week or
two while holding up 2.6.22.  I can only think we must enjoy doing it this way.
