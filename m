Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbXLBMhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbXLBMhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 07:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXLBMgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 07:36:52 -0500
Received: from lazybastard.de ([212.112.238.170]:48256 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXLBMgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 07:36:51 -0500
Date: Sun, 2 Dec 2007 13:31:25 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071202123125.GA9516@lazybastard.org>
References: <20071130134312.GA32273@elte.hu> <20071130183510.GA1570@lazybastard.org> <20071130184625.GB9928@elte.hu> <20071201151650.GA5031@lazybastard.org> <20071201183256.GA14052@elte.hu> <20071201204747.GA6458@lazybastard.org> <20071201205456.GA8231@elte.hu> <20071201234112.GA7209@lazybastard.org> <20071202085607.GA28966@elte.hu> <20071202113143.GA9378@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071202113143.GA9378@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 December 2007 12:31:43 +0100, Jörn Engel wrote:
> 
> This time not even the offsets have changed.  Dump is identical.

After another ten or so notrace annotations throughout the spinlock
code, the latency tracer appears to work.  Not sure how many useful
information is missing through all the annotations, though.

Jörn

-- 
Das Aufregende am Schreiben ist es, eine Ordnung zu schaffen, wo
vorher keine existiert hat.
-- Doris Lessing
