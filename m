Return-Path: <linux-kernel-owner+w=401wt.eu-S1762387AbYAKTKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762387AbYAKTKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760397AbYAKTJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:09:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34833 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019AbYAKTJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:09:57 -0500
Date: Fri, 11 Jan 2008 11:09:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       inux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080111110931.323ee056@laptopd505.fenrus.org>
In-Reply-To: <20080111190229.GB10112@kroah.com>
References: <20071225032605.29147200@laptopd505.fenrus.org>
	<20080111190229.GB10112@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 11:02:29 -0800
Greg KH <greg@kroah.com> wrote:

> On Tue, Dec 25, 2007 at 03:26:05AM -0800, Arjan van de Ven wrote:
> > 
> > This patch also adds a sysfs property for each device into which
> > root can write a '1' to enable extended configuration space. The
> > kernel will print a notice into dmesg when this happens (including
> > the name of the app) so that if the system crashes as a result of
> > this action, the user can know what action/tool caused it.
> 
> Can you send me a follow-on patch that documents this in
> Documentation/ABI please.
> 

once it's stable enough, say after 1 kernel release, sure

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
