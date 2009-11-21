Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbZKUKv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbZKUKv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 05:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZKUKvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 05:51:55 -0500
Received: from lazybastard.de ([212.112.238.170]:35092 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZKUKvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 05:51:54 -0500
X-Greylist: delayed 1569 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2009 05:51:54 EST
Date: Sat, 21 Nov 2009 11:25:43 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Maxim Levitsky <slevmax@t2.technion.ac.il>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutonix.de
Subject: Re: XD/smartmedia - how to implement it right?
Message-ID: <20091121102542.GA21136@logfs.org>
References: <1258763144.4997.12.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1258763144.4997.12.camel@maxim-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 November 2009 02:25:44 +0200, Maxim Levitsky wrote:
> 
> This thread is meant to continue discussion about XD/smartmedia support
> in linux.
> 
> I CC'd few peoples that participated in original discussion.
> 
> Alex Dubov attempted to write a driver for jmicron device (I have it
> btw), but this was rejected due to code duplication.
> 
> I successfully reverse engineered (in my free time) the XD card reader
> found on my laptop (ricoh based one)
> 
> I would like to know how you think to implement the subsystem support
> right.
> 
> I would go with mmc subsystem + FTL, but according to original thread,
> there are numerous problems with this approach.
> 
> Any advice is appreciated.

A novel approach might be to just send the code as a patch.  Last time
around noone seemed to have had a real look.

The "mtd uses blocking calls" argument I can help with.  For some other
project I've added non-blocking calls to mtd[1].

Biggest problems I see are a) the userspace interface and b) allowing
both raw flash access through MTD and block device access with an FTL.

[1] http://lists.infradead.org/pipermail/linux-mtd/2009-November/028065.html

Jörn

-- 
The wise man seeks everything in himself; the ignorant man tries to get
everything from somebody else.
-- unknown
