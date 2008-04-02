Return-Path: <linux-kernel-owner+w=401wt.eu-S933316AbYDBUoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316AbYDBUoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765756AbYDBUhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:37:15 -0400
Received: from nn7.de ([85.214.94.156]:59546 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765745AbYDBUhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:37:14 -0400
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
From: Soeren Sonnenburg <kernel@nn7.de>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       linux-usb@vger.kernel.org, "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
In-Reply-To: <20080402194757.GA5082@dose.home.local>
References: <20080401210617.GA7346@dose.home.local>
	 <Pine.LNX.4.44L0.0804021521260.11421-100000@iolanthe.rowland.org>
	 <20080402194757.GA5082@dose.home.local>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 02 Apr 2008 22:37:10 +0200
Message-Id: <1207168630.4184.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 21:47 +0200, Tino Keitel wrote:
> On Wed, Apr 02, 2008 at 15:26:44 -0400, Alan Stern wrote:
> > On Tue, 1 Apr 2008, Tino Keitel wrote:
> > 
> > > On Tue, Apr 01, 2008 at 17:02:36 -0400, Alan Stern wrote:
> > > > On Tue, 1 Apr 2008, Tino Keitel wrote:
> > > > 
> > > > > On Tue, Apr 01, 2008 at 15:06:51 -0400, Alan Stern wrote:
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > Can you get any information out of the computer after the hang?  It 
> > > > > > would help to see the dmesg log (with CONFIG_USB_DEBUG enabled) and an 
> > > > > > Alt-SysRq-T stack dump.
> > > > > 
> > > > > Looks difficult. The text console stays black after resume, and there
> > > > > is no serial interface.
> > > > 
> > > > Network console?  SSH?  Or even telnet?
> > > 
> > > Network is dead, too.
> > 
> > Tino, try this patch.  It fixed Mark Lord's problem, which looked the 
> > same as yours.
> 
> Fine, it seems to solve the hang, I see no problems after the resume.
> Thanks a lot.

Using this patch fixes the hang for my macbookpro1,1 too. However the
console stays black after resume, though I can s2ram multiple times and
reboot...

Soeren
