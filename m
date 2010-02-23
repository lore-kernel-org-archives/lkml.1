Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0BWOfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:35:42 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:44820 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157Ab0BWOfk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:35:40 -0500
Subject: Re: [PATCH] Staging: wlan-ng: Fix 80 character limit warnings
 Fixed 2  warnings identified by the checkpatch.pl tool which occured due to
 two lines  of code going over the 80 character limit. Fixed by wrapping the
 lines.  Signed-off-by: Jim Dog <jimdog@
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
       jimdog@northern-indymedia.org
Cc: gregkh@suse.de, jmm@debian.org, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <69e28c911002210706k1a5ae686r76df74a743dcce1c@mail.gmail.com>
References: <69e28c911002210706k1a5ae686r76df74a743dcce1c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 14:35:35 +0000
Message-ID: <1266935735.2047.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-21 at 16:06 +0100, Gábor Stefanik wrote:

> > +/*
> > +       {PRISM_USB_DEVICE(0x0ace, 0x1201, "ZyDAS ZD1201 Wireless USB Adapter")},
> > +*/
> 
> Why is this even included? We do have support for this in zd1201, and
> I'm pretty sure wlan-ng doesn't actually handle it.
> 
In that case, let's just remove it. It's only clutter and may cause
confusion.
JD do you want to update your patch to get rid of this?

regards
Richard 

