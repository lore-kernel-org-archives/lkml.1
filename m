Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbXKATrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbXKATrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbXKATrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:47:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42590 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753495AbXKATrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:47:08 -0400
Date: Thu, 1 Nov 2007 15:47:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tilman Schmidt <tilman@imap.cc>
cc: Andrew Morton <akpm@linux-foundation.org>,
       <linux-usb-devel@lists.sourceforge.net>, <kkeil@suse.de>,
       <gregkh@suse.de>, <linux-kernel@vger.kernel.org>, <hjlipp@web.de>,
       <i4ldeveloper@listserv.isdn4linux.de>
Subject: Re: [linux-usb-devel] [PATCH 1/2] usb_gigaset: suspend support [v2]
In-Reply-To: <472A18D7.7020703@imap.cc>
Message-ID: <Pine.LNX.4.44L0.0711011546090.6180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Tilman Schmidt wrote:

> Anyway, to be sure these checks aren't needed, I would need the
> assurance that the suspend and resume methods are serialized with
> the probe and disconnect methods. Are they?

Yes.  See Documentation/usb/power-management.txt.

Alan Stern

