Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbXGJPa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbXGJPa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbXGJPaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:30:20 -0400
Received: from mail.suse.de ([195.135.220.2]:59278 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbXGJPaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:30:19 -0400
Date: Tue, 10 Jul 2007 14:04:08 +0200
From: Stefan Seyfried <seife@suse.de>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: nigel@suspend2.net, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com
Subject: Re: Failure to properly reinit i8042 post suspend-to-ram
Message-ID: <20070710120408.GA4188@suse.de>
References: <200706221607.33274.nigel@nigel.suspend2.net> <200707052104.27693.nigel@nigel.suspend2.net> <20070706150451.GA11400@suse.de> <200707101059.57881.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707101059.57881.nigel@nigel.suspend2.net>
X-Operating-System: openSUSE 10.3 (i586) Alpha5plus, Kernel 2.6.22-rc7-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 10, 2007 at 10:59:57AM +1000, Nigel Cunningham wrote:
> On Saturday 07 July 2007 01:04:51 Stefan Seyfried wrote:
> > On Thu, Jul 05, 2007 at 09:04:27PM +1000, Nigel Cunningham wrote:
> > > 
> > > Adding i8042.reset=1 to the commandline fixed it.
> > 
> > Wasn't there a quirk list where workarounds for i8042 on known bad machines
> > are stored? Maybe it would be a good idea to get your machine into it ;-)
> 
> Unless I'm missing something, it looks like there's no such thing in the i8042 
> driver. That's okay. I can cope with adding i8042.reset=1 to my 
> commandline :)

In drivers/input/serio/i8042-x86ia64io.h there are tables for various quirks,
but apparently nothing for "reset=1".
If we find another machine that needs reset=1, then it might be time for a
table for this quirk.

Best regards,

    Stefan

-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
