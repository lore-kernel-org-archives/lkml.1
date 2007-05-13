Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbXEMRtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbXEMRtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 13:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXEMRtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 13:49:16 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:34484 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753827AbXEMRtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 13:49:15 -0400
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <46474E1A.6080904@simon.arlott.org.uk>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain>
	 <1179073670.3723.48.camel@mulgrave.il.steeleye.com>
	 <46474E1A.6080904@simon.arlott.org.uk>
Content-Type: text/plain
Date: Sun, 13 May 2007 12:48:56 -0500
Message-Id: <1179078537.3723.53.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 18:42 +0100, Simon Arlott wrote:
> > If you set CONFIG_MODULE=y and build SCSI we assume you could have a
> > SCSI driver module at some point, which would necessitate the wait scan
> > module.
> 
> This should be implemented like "Library routines" and only added if such 
> a SCSI driver module is actually selected. Why can't it at least be a 
> visible option in the menu? (Although even then it looks like it's 
> impossible to disable).

There's out of tree modules to consider.

> Why does ATA select SCSI anyway? Surely PATA doesn't require it?

That's a bit offtopic and to the wrong list.

libata-pata does require SCSI ... and I suspect the libata developers
didn't want to trip users by them having to select SCSI before they
could select libata.

James


