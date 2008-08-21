Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYHUJg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYHUJg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 05:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYHUJgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 05:36:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:55390 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbYHUJgp (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 05:36:45 -0400
Subject: Re: [PATCH 05/10] AXFS: axfs_profiling.c
From: David Woodhouse <dwmw2@infradead.org>
To: carsteno@de.ibm.com
Cc: jaredeh@gmail.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@AM.SONY.COM,
       nickpiggin@yahoo.com.au
In-Reply-To: <48AD2AFF.5060609@de.ibm.com>
References: <48AD00F8.1030004@gmail.com>  <48AD2AFF.5060609@de.ibm.com>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 09:49:19 +0100
Message-Id: <1219308560.2988.247.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 10:44 +0200, Carsten Otte wrote:
> Jared Hulbert wrote:
> > Profiling is a fault instrumentation and /proc formating system.
> > This is used to get an accurate picture of what the pages are actually used.
> > Using this info the image can be optimized for XIP

> Exporting profiling data for a file system in another file system 
> (/proc) seems not very straigtforward to me. I think it is worth 
> considering to export this information via the same mount point.

I would have said sysfs, rather than 'the same mount point'.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



