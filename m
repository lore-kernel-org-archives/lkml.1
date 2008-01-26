Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYAZGbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYAZGbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 01:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYAZGbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 01:31:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50162 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYAZGbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 01:31:41 -0500
Date: Fri, 25 Jan 2008 22:31:34 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
Message-ID: <20080125223134.74664403@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
References: <20080125071127.GA4860@kroah.com>
	<alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
	<20080125185213.GA23475@suse.de>
	<alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008 11:11:48 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 25 Jan 2008, Greg KH wrote:
> > 
> > That's really wierd, I don't see that at all here just running with
> > your 2.6.24 + my git tree and lots of USB drivers built into the
> > kernel also (like ehci_hcd).
> 
> But do you use an initrd that tries to load the same driver too?
> 
> I'm too lazy to want to do my own initrd. I just use the prepackaged
> ones and rely on the fact that my private kernel will refuse to load
> modules that aren't meant for it anyway.
> 

you know about "make install" right? That copies the needed files to /boot,
adds them to grub AND makes an initrd for you.. all for free ;)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
