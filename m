Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbXLDAMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbXLDAMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 19:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXLDAMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 19:12:47 -0500
Received: from lazybastard.de ([212.112.238.170]:38108 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbXLDAMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 19:12:47 -0500
Date: Tue, 4 Dec 2007 01:06:55 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071204000655.GA17212@lazybastard.org>
References: <20071202135711.GA20434@elte.hu> <20071202141117.GB9516@lazybastard.org> <20071202154746.GA27069@elte.hu> <20071202195501.GB10657@lazybastard.org> <20071202200722.GA12101@elte.hu> <20071202203016.GC10657@lazybastard.org> <20071202204559.GA28550@elte.hu> <20071202211026.GB11522@lazybastard.org> <20071202211900.GB7439@elte.hu> <20071203005702.GA12215@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071203005702.GA12215@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 December 2007 01:57:02 +0100, Jörn Engel wrote:
> 
> After an eternity of compile time, this config does generate some useful
> output.  qemu is not to blame.

Or is it?  The output definitely looks suspicious.  Large amounts of
code get processed within a microsecond, while update_wall_time()
appears to cause huge delays every time it is called:
http://logfs.org/~joern/trace

Does this output make sense or does it rather indicate some sloppiness
wrt. time in the qemu virtual machine?

Jörn

-- 
tglx1 thinks that joern should get a (TM) for "Thinking Is Hard"
-- Thomas Gleixner
