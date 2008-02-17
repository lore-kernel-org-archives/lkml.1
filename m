Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYBQCaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYBQCaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYBQCaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:30:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37913 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYBQCaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:30:05 -0500
Date: Sat, 16 Feb 2008 18:29:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What's needed for a PCIe card to be recognized?
Message-ID: <20080216182939.061c7246@laptopd505.fenrus.org>
In-Reply-To: <20080217015453.2a4e4142@dilbert.local>
References: <20080216225932.22460d31@dilbert.local>
	<20080216143946.6d532a41@laptopd505.fenrus.org>
	<20080217015453.2a4e4142@dilbert.local>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 01:54:53 +0100
Hans-Jürgen Koch <hjk@linutronix.de> wrote:

> Am Sat, 16 Feb 2008 14:39:46 -0800
> schrieb Arjan van de Ven <arjan@infradead.org>:
> 
> > On Sat, 16 Feb 2008 22:59:32 +0100
> > Hans-Jürgen Koch <hjk@linutronix.de> wrote:
> > 
> > > I'm playing around with a vanilla 2.6.25-rc1, adding patches to
> > > make it work on an Asus EeePC. That one has the problem that its
> > > Mini PCIe WLAN module doesn't show up in lspci. That brought up a
> > > few questions that I couldn't answer yet:
> > > 
> > > How can they "hide" a PCIe card?
> > > What could be their motive to do that?
> > > How can I make it appear?
> > 
> > 
> > go to the bios, enable the wireless card. 
> > 
> > that did it for me ;)
> 
> It didn't for me. I tried all combinations (booting with/without WLAN
> enabled, enabling WLAN through /proc with/without pciehp loaded and so
> on). What kernel did you use, and which patches did you apply?
> 

I used a pretty much stock Fedora 8 kernel.. no magic patches at all.
Of course there's no driver for the wlan, but that's a different story ;)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
