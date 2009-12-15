Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZLOAkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZLOAkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbZLOAkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:40:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbZLOAkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:40:10 -0500
Date: Mon, 14 Dec 2009 16:39:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
In-Reply-To: <20091211212646.GB6624@kroah.com>
Message-ID: <alpine.LFD.2.00.0912141635000.14385@localhost.localdomain>
References: <20091211212646.GB6624@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Dec 2009, Greg KH wrote:
>
> Here is the big USB merge for the 2.6.33-git tree.

I haven't bisected this yet, but something bad has happened to the USB 
printer connected to Tove's computer since 2.6.32. Current -git doesn't 
work, 2.6.32 works fine.

The USB pull is obviously an easy suspect, but on the other hand the code 
still sees the printer - but for some reason Fedora-11 print manager still 
complains about it perhaps being unconnected (and is unable to see any 
printer if I try to go into "Printer admin" and remove and add the 
printer)..

Booting back into 2.6.32 gets me a fine working printer again.

Does this ring a bell for anybody? The bisect is ongoing, but it will take 
some time (at least 12 more compiles and reboots - I just started).

			Linus
