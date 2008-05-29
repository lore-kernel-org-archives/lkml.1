Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYE2SX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYE2SX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYE2SXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:23:48 -0400
Received: from tesla.selinc.com ([12.110.71.2]:52487 "EHLO tesla.selinc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbYE2SXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:23:48 -0400
In-Reply-To: <200805291104.30779.david-b@pacbell.net>
To: Li Yang <leoli@freescale.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] fsl_usb2_udc: fix recursive lock
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OFE47F9BEE.971C92BB-ON88257458.0064D160-88257458.00650986@selinc.com>
From: Eugene_Bordenkircher@selinc.com
Date: Thu, 29 May 2008 11:23:34 -0700
X-MIMETrack: Serialize by Router on Edison2/SEL(Release 7.0.3|September 26, 2007) at 05/29/2008
 11:23:37 AM,
	Serialize complete at 05/29/2008 11:23:37 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ... clearly, 2.6.26 material; the same locking problem also
> shows up on non-RT kernels.
> 

I agree.  I just happened to be working with an RT patched kernel when the 
BUG was generated.

The patch appears to be working correctly.

Thanks,

Eugene
