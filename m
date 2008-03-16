Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYCPWdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYCPWdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYCPWdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:33:05 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:35274 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752353AbYCPWdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:33:04 -0400
X-YMail-OSG: b.qrqCAVM1lCA8lGH.IcocptkLL0cmz4FMz0Q5qKVDvmJUGGKeAHlmc.yYQE.6RC9LG7sjCBXMhIdIJ6W8KxkiR1.crc2zvpwID5a82ZB9xAHnmMHA--
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 16 Mar 2008 15:32:57 -0700
From: Chris Wedgwood <cw@f00f.org>
To: David Brownell <david-b@pacbell.net>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, linux-kernel@vger.kernel.org,
       Rabeeh Khoury <rabeeh@marvell.com>
Subject: USB oops with mainline (post 2.6.25-rc5)
Message-ID: <20080316223257.GA4095@puku.stupidest.org>
References: <20080312093045.GA24017@xi.wantstofly.org> <200803120238.49050.david-b@pacbell.net> <20080312101131.GC24017@xi.wantstofly.org> <200803120313.23568.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803120313.23568.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 02:13:23AM -0800, David Brownell wrote:

> Sorry, I forgot that made it just *after* RC5.  That's the patch I
> was interested in.

That's not enough to prevent the oops here.  Using mainline from about
an hour ago I get a crash inside ub_end_rq.  No full oops (yet) but
pic at http://stupidest.org/tmp/2.6.25-rc5-cw3-usboops1.png if that
helps.  Should I back out all the USB changes of late and see if that
helps?

I got that a second or so after inserting a USB storage device.
