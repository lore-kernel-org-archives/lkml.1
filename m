Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbXFUTD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbXFUTD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbXFUTDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:03:52 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:36991 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbXFUTDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:03:52 -0400
Date: Thu, 21 Jun 2007 12:02:28 -0700
From: Reza Roboubi <reza@earthdetails.com>
Subject: O_DIRECT, fdatasync_area, mwrite
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org
Message-id: <467ACB44.50209@earthdetails.com>
Organization: Earth Details
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds:
 > I suspect that this is about a few hundred lines of code (and a lot of
 > testing). And you can emulate O_DIRECT behavior with it, along with
 > splice (only for page-cache entities, though), and a lot of other
 > off-by-one uses.
( http://lwn.net/2002/0516/a/lt-async.php3 )

I have often read this message and wondered why no one has implemented 
it yet.  We would love to have such clean features instead of O_DIRECT. 
  At this very moment it's a bit hard for us to do this(given a 
prerequisites learning curve amongst other factors.)  We may at some 
point do it and I'd love to contribute.  What _are_ the issues with it, 
  and is there a technical reason it hasn't been implemented yet by anybody?

Further, is O_DIRECT to raw partition also unclean?

Thanks.

Reza.
-- 
Reza Roboubi
Chief Technical Officer
http://www.EarthDetails.com
