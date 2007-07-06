Return-Path: <linux-kernel-owner+w=401wt.eu-S1762388AbXGFPJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762388AbXGFPJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbXGFPJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:09:04 -0400
Received: from mail.suse.de ([195.135.220.2]:59000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234AbXGFPJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:09:03 -0400
Date: Fri, 6 Jul 2007 17:04:51 +0200
From: Stefan Seyfried <seife@suse.de>
To: nigel@suspend2.net
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       dmitry.torokhov@gmail.com
Subject: Re: Failure to properly reinit i8042 post suspend-to-ram
Message-ID: <20070706150451.GA11400@suse.de>
References: <200706221607.33274.nigel@nigel.suspend2.net> <20070705101514.GD3984@ucw.cz> <200707052104.27693.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707052104.27693.nigel@nigel.suspend2.net>
X-Operating-System: openSUSE 10.3 (i586) Alpha5plus, Kernel 2.6.22-rc7-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 09:04:27PM +1000, Nigel Cunningham wrote:
> > 
> > If confusion persist after 4 seconds hard power down... then you h ve
> > hw/BIOS problem. Complain to whoever is manufacturing that beast.
> 
> Adding i8042.reset=1 to the commandline fixed it.

Wasn't there a quirk list where workarounds for i8042 on known bad machines
are stored? Maybe it would be a good idea to get your machine into it ;-)
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
