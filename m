Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbXENRdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbXENRdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbXENRd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:33:29 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:34773 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256AbXENRd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:33:28 -0400
Date: Mon, 14 May 2007 19:29:12 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: Simon Arlott <simon@fire.lp0.eu>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
In-Reply-To: <1179078537.3723.53.camel@mulgrave.il.steeleye.com>
Message-ID: <Pine.LNX.4.61.0705141928230.9570@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain> 
 <20070513160608.GA29024@redhat.com>  <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
  <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain> 
 <1179073670.3723.48.camel@mulgrave.il.steeleye.com>  <46474E1A.6080904@simon.arlott.org.uk>
 <1179078537.3723.53.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 13 2007 12:48, James Bottomley wrote:
>
>> Why does ATA select SCSI anyway? Surely PATA doesn't require it?
>
>That's a bit offtopic and to the wrong list.
>
>libata-pata does require SCSI ...

And in the long run, that SCSI parts which are actually used by ATA
should be factored out so that SCSI really is SCSI again, and not
"Common layer for SCSI, SATA and PATA" or so.

	Jan
-- 
