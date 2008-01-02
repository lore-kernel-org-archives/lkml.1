Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYABKQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYABKQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYABKPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:15:53 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:33233 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYABKPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:15:52 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-usb-devel] [FEATURE REQUEST] Transparent hot plugging of root file system on portable storage devices.
Date: Wed, 2 Jan 2008 11:19:21 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Raymano Garibaldi <raymano@faunos.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
References: <1618816c0711261104m3177a2bas24446035557f9593@mail.gmail.com> <20080101202945.GA14190@ucw.cz>
In-Reply-To: <20080101202945.GA14190@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021119.22104.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 01 Januar 2008 schrieb Pavel Machek:
> Hi1
> 
> > I would like to request a feature in the Linux kernel that would allow
> > a user to unplug a live read-only root file system which exists on a
> > detachable storage device such as a USB key drive. The desired
> > behavior is that once the same device is reattached to the computer
> > the user can continue work transparently without having to reboot.
> > 
> > Having such a feature is becoming more important with advances in
> > detachable solid state drive technology.
> 
> Yep, that would be nice.... In fact, patch would be very welcome :-).

Use the USB persist feature and hibernate. It should work. If you modify
the fs in any way, you'll crash and burn. Unmounting / is harder which you
need if you want to do this safely.

	Regards
		Oliver

