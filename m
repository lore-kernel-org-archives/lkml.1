Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZKIOYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZKIOYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZKIOYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:24:44 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61029 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZKIOYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:24:43 -0500
Date: Mon, 9 Nov 2009 16:24:30 +0200
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: iio: tsl2563 ambient light sensor driver
Message-ID: <20091109142430.GZ1773@smtp.gmail.com>
Mail-Followup-To: Jonathan Cameron <jic23@cam.ac.uk>,
	List Linux Kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-omap@vger.kernel.org
References: <1257772468-4004-1-git-send-email-amit.kucheria@verdurent.com>
 <4AF81FE5.5080102@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4AF81FE5.5080102@cam.ac.uk>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Nov 09, Jonathan Cameron wrote:
> Hi Amit,
> 
> Normally I'd welcome this in IIO, except that all ambient light sensors are in the
> process of moving to the new ALS subsystem.  There are still some issues to resolve
> in that subsystem (mainly to do with naming conventions) but hopefully we will
> get them sorted out shortly.

Groan! :) Who will be the subsystem maintainer and is there already a public git
tree?

> I'll take a close look at this sometime over the next few days though.  On a quick
> glance at the data sheet, it looks very similar to the tsl2561.  Perhaps we can merge
> the drivers? Yours is certainly more complete than the tsl2561 version in IIO so it
> would make sense to lift the functional elements in to the code I have for an ALS
> driver. I hadn't posted that previously as I hadn't quite worked out how to handle
> the various gain related settings. What you have done seems to make sense (from a very
> quick look.)

I've got no problem merging the tsl2563 with 2561. I don't have any 2561
hardware to check a merged driver though.


Do you think the ALS framework will be finalised before the 2.6.33 merge
window (in a few weeks)? If not, I wonder if Greg would take this driver to
staging to begin with and I'll modify it to use the ALS subsystem when it
settles down.

Regards,
Amit
