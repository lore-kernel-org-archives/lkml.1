Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbYDDNZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbYDDNZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYDDNZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:25:43 -0400
Received: from 162.242-241-81.adsl-static.isp.belgacom.be ([81.241.242.162]:59711
	"EHLO grep.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751391AbYDDNZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:25:42 -0400
Date: Wed, 2 Apr 2008 15:44:14 +0200
From: Wouter Verhelst <w@uter.be>
To: Paul Clements <paul.clements@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       nbd-general@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: [Nbd] [PATCH 1/1] NBD: add partition support
Message-ID: <20080402134414.GA4192@country.nixsys.be>
References: <47F2A5A1.3010308@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F2A5A1.3010308@steeleye.com>
X-Speed: Gates' Law: Every 18 months, the speed of software halves.
Organization: none
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 05:14:09PM -0400, Paul Clements wrote:
> Below, Laurent notes that partition table re-read doesn't automatically  
> occur. For now you'll have to open("/dev/nbdX") to get that to happen.
> Longer term, nbd-client can be modified to fork just before nbd_do_it()  
> and then call ioctl(BLKRRPART, "/dev/nbdX") in the parent process  
> (probably need to wait for the "pid" file to show up in /sys to avoid a  
> race).

I just released nbd-2.9.10, which does just that.

-- 
<Lo-lan-do> Home is where you have to wash the dishes.
  -- #debian-devel, Freenode, 2004-09-22
