Return-Path: <linux-kernel-owner+w=401wt.eu-S1161352AbXDKXNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161352AbXDKXNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161346AbXDKXNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:13:45 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51531 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161352AbXDKXNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:13:44 -0400
Date: Thu, 12 Apr 2007 01:07:00 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-ID: <20070411230700.GA4023@aitel.hist.no>
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411134346.d10765da.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 01:43:46PM -0700, Andrew Morton wrote:
> 
> OK.  If you add initcall_debug to the kernel boot command line, what's the
> last thing we call?

The last messages (handwritten, somewhat shortened)
calling hid_init+0x0/0x10()
returned 0
ran for 0 msec
calling hid_init+0x0/0x50()
usbcore registered new interface driver hiddev

and then it hangs completely.

Helge Hafting
