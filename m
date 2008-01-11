Return-Path: <linux-kernel-owner+w=401wt.eu-S1761772AbYAKVDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772AbYAKVDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbYAKVCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:02:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56345 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759109AbYAKVCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:02:54 -0500
Date: Fri, 11 Jan 2008 12:55:56 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       inux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080111205556.GA22593@kroah.com>
References: <20071225032605.29147200@laptopd505.fenrus.org> <20080111190229.GB10112@kroah.com> <20080111115456.1fd83d88@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111115456.1fd83d88@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 11:54:56AM -0800, Arjan van de Ven wrote:
> On Fri, 11 Jan 2008 11:02:29 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Tue, Dec 25, 2007 at 03:26:05AM -0800, Arjan van de Ven wrote:
> > > 
> > > This patch also adds a sysfs property for each device into which
> > > root can write a '1' to enable extended configuration space. The
> > > kernel will print a notice into dmesg when this happens (including
> > > the name of the app) so that if the system crashes as a result of
> > > this action, the user can know what action/tool caused it.
> > 
> > Can you send me a follow-on patch that documents this in
> > Documentation/ABI please.
> > 
> 
> ---
>  Documentation/ABI/testing/sysfs-pci-extended-config |   39 ++++++++++++++++++++
>  1 file changed, 39 insertions(+)

Thanks, I've merged this with the original one.

greg k-h
