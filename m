Return-Path: <linux-kernel-owner+w=401wt.eu-S1766006AbYD1HPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766006AbYD1HPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763654AbYD1HPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:15:03 -0400
Received: from styx.suse.cz ([82.119.242.94]:54556 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763390AbYD1HPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:15:02 -0400
Date: Mon, 28 Apr 2008 09:15:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Al Viro <viro@ftp.linux.org.uk>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] usbhid endianness annotations and fixes
In-Reply-To: <E1JqMPF-0004oO-W8@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0804280914310.7756@jikos.suse.cz>
References: <E1JqMPF-0004oO-W8@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Al Viro wrote:

> usb_control_msg() converts arguments to little-endian itself,
> doing that in caller means breakage on big-endian boxen.

Thanks a lot for spotting this, applied to my tree.

-- 
Jiri Kosina
