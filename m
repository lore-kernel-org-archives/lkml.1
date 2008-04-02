Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYDBTrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYDBTrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757041AbYDBTrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:47:15 -0400
Received: from eazy.amigager.de ([213.239.192.238]:55167 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbYDBTrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:47:14 -0400
Date: Wed, 2 Apr 2008 21:47:58 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, linux-usb@vger.kernel.org,
       Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
Message-ID: <20080402194757.GA5082@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Pavel Machek <pavel@ucw.cz>, linux-usb@vger.kernel.org,
	Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <20080401210617.GA7346@dose.home.local> <Pine.LNX.4.44L0.0804021521260.11421-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0804021521260.11421-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 15:26:44 -0400, Alan Stern wrote:
> On Tue, 1 Apr 2008, Tino Keitel wrote:
> 
> > On Tue, Apr 01, 2008 at 17:02:36 -0400, Alan Stern wrote:
> > > On Tue, 1 Apr 2008, Tino Keitel wrote:
> > > 
> > > > On Tue, Apr 01, 2008 at 15:06:51 -0400, Alan Stern wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > Can you get any information out of the computer after the hang?  It 
> > > > > would help to see the dmesg log (with CONFIG_USB_DEBUG enabled) and an 
> > > > > Alt-SysRq-T stack dump.
> > > > 
> > > > Looks difficult. The text console stays black after resume, and there
> > > > is no serial interface.
> > > 
> > > Network console?  SSH?  Or even telnet?
> > 
> > Network is dead, too.
> 
> Tino, try this patch.  It fixed Mark Lord's problem, which looked the 
> same as yours.

Fine, it seems to solve the hang, I see no problems after the resume.
Thanks a lot.

Regards,
Tino
