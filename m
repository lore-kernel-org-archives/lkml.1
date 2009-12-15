Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbZLOBA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbZLOBA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbZLOBAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:00:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758360AbZLOBAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:00:22 -0500
Date: Mon, 14 Dec 2009 17:00:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
In-Reply-To: <20091215005216.GA9309@kroah.com>
Message-ID: <alpine.LFD.2.00.0912141658290.14385@localhost.localdomain>
References: <20091211212646.GB6624@kroah.com> <alpine.LFD.2.00.0912141635000.14385@localhost.localdomain> <20091215005216.GA9309@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Dec 2009, Greg KH wrote:
> 
> Any kind of kernel log messages?  This would be a USB 2.0 device, right?

There's no odd messages. I see the regular connect and disconnect 
messages, so I know the USB layer _saw_ the printer. But apart from that, 
nothing actually happens. And no printout.

> Hm, I just tried to print from mine on your latest tree, and I have a
> stream of:

Ahha. So I'm not the only one. 

Will continue to bisect.

		Linus
