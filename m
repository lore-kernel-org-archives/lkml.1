Return-Path: <linux-kernel-owner+w=401wt.eu-S1767045AbXEBVjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767045AbXEBVjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767043AbXEBVjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:39:09 -0400
Received: from rtr.ca ([64.26.128.89]:3163 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767045AbXEBVjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:39:08 -0400
Message-ID: <463904F4.8030709@rtr.ca>
Date: Wed, 02 May 2007 17:39:00 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [BUG] usb/core/hub.c loops forever on resume
 from ram due to bluetooth
References: <Pine.LNX.4.44L0.0705021557470.2628-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705021557470.2628-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> 
> A better approach would be to find out why your system gets into that loop 
> and fix the underlying cause.

Not better, just parallel.

That loop should not be unbounded, as this example proves.
But it also shouldn't get stuck there regardless.

Two fixes needed.

Cheers
