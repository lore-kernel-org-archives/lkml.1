Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbXEOAIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbXEOAIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbXEOAII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:08:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47334 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbXEOAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:08:07 -0400
Subject: Re: +
	timer_stats-slimmed-down-using-statistics-infrastucture.patch added to -mm
	tree
From: Arjan van de Ven <arjan@infradead.org>
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de
In-Reply-To: <46481D18.7080302@de.ibm.com>
References: <200704210018.l3L0IJBN027188@shell0.pdx.osdl.net>
	 <1179082720.19106.4.camel@laptopd505.fenrus.org>
	 <46481D18.7080302@de.ibm.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 14 May 2007 17:06:18 -0700
Message-Id: <1179187579.3654.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 10:26 +0200, Martin Peschke wrote:
> >
> >> [root@t2930041 timer_stats]# cat data
> > 
> > this patch changes the userspace API though, and breaks PowerTOP :(
> 
> Though I think it was unfortunate to add the "old" proc API in 2.6.21.
> timer_stats is clearly labeled as debug stuff in config help, which is why 
> debugfs would have been a proper place.

but it's not there, it's in it's current place. And userspace apps
depend on it... so what's the reason to change this after it became
ABI ? If there's a good one I can fix powertop.. but.... 
oh well I hope you kept the rest of the file format the same ;)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

