Return-Path: <linux-kernel-owner+w=401wt.eu-S1423211AbXBITKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423211AbXBITKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423238AbXBITKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:10:39 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:49297 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423211AbXBITKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:10:39 -0500
Message-ID: <45CCC72A.8020904@drzeus.cx>
Date: Fri, 09 Feb 2007 20:10:34 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver
References: <555089.84713.qm@web36703.mail.mud.yahoo.com>
In-Reply-To: <555089.84713.qm@web36703.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> I'm continuing to look for possible problems in my code.
> 

This looks like the problem with races in mmc_block again. Add some printk:s in
the remove function so that you can see if this oops is after the remove
function (shouldn't be possible, but will cause crash if it is).

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
