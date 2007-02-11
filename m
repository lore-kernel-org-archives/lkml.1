Return-Path: <linux-kernel-owner+w=401wt.eu-S1750743AbXBKRYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750743AbXBKRYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbXBKRYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:24:32 -0500
Received: from styx.suse.cz ([82.119.242.94]:40569 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750743AbXBKRYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:24:32 -0500
Date: Sun, 11 Feb 2007 18:24:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Julien BLACHE <jb@jblache.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] Fix USB vendor and product IDs endianness for USB HID
 devices
In-Reply-To: <87k5yp90v1.fsf@sonic.technologeek.org>
Message-ID: <Pine.LNX.4.64.0702111822190.22290@jikos.suse.cz>
References: <87k5yp90v1.fsf@sonic.technologeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007, Julien BLACHE wrote:

> The generic HID layer changes introduced an endianness bug for USB HID
> devices.

Hi Julien,

this is obviously a bug, thanks for a fix, I queued it for upstream.

Two nitpicks:

- could you please submitpatches in standard conventions, so that they 
  could be applied directly using patch -p1 against toplevel of the kernel 
  tree (your patch was just against hid-core.c, but without any path)
- please inline patches in message and do not attach them, if possible

I will submit the patch to stable team.

Thanks,

-- 
Jiri Kosina
SUSE Labs
