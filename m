Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbYDQVWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbYDQVWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYDQVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:21:53 -0400
Received: from lazybastard.de ([212.112.238.170]:49149 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYDQVVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:21:52 -0400
Date: Thu, 17 Apr 2008 23:21:38 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alex Dubov <oakad@yahoo.com>, Ben Dooks <ben@fluff.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Smartmedia/xd card support - request for comments
Message-ID: <20080417212138.GA343@logfs.org>
References: <257448.48285.qm@web36701.mail.mud.yahoo.com> <alpine.LFD.1.10.0804171535581.3261@apollo.tec.linutronix.de> <20080417140734.GA30001@logfs.org> <alpine.LFD.1.10.0804172109170.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0804172109170.3261@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 April 2008 21:11:30 +0200, Thomas Gleixner wrote:
> 
> Oops. I did not bother to look into drivers/mtd and for some reason it
> slipped out of my memory that it got mainlined. It's read only, but
> the missing bits to make it r/w are not that hard. At least less code
> than duplicating code all over the place for no good reason.

Indeed.  If some janitor or kernel-newbie is looking for a fun project,
most of the code in drivers/usb/storage/*.c can be abstracted out to a
library implementation and possibly combined with drivers/mtd/ssfdc.c,
drivers/mtd/nand/alauda.c and some others.

Jörn

-- 
The only good bug is a dead bug.
-- Starship Troopers
