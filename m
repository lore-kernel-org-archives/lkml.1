Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbXEMQnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbXEMQnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759104AbXEMQnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:43:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130AbXEMQnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:43:11 -0400
Date: Sun, 13 May 2007 12:43:03 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: undeprecate raw driver.
Message-ID: <20070513164303.GF27604@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070513163220.GA31902@redhat.com> <Pine.LNX.4.61.0705131835110.9570@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705131835110.9570@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 06:35:45PM +0200, Jan Engelhardt wrote:

 > >-	tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"
 > >+	tristate "RAW driver (/dev/raw/rawN)"
 > > 	depends on BLOCK
 > > 	help
 > >-	  The raw driver permits block devices to be bound to /dev/raw/rawN. 
 > >-	  Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O. 
 > >+	  The raw driver permits block devices to be bound to /dev/raw/rawN.
 > >+	  Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
 > > 	  See the raw(8) manpage for more details.
 > > 
 > >-          The raw driver is deprecated and will be removed soon.
 > >-          Applications should simply open the device (eg /dev/hda1)
 > >+          Applications should preferably open the device (eg /dev/hda1)
 > >           with the O_DIRECT flag.
 > > 
 > > config MAX_RAW_DEVS
 > 
 > At least keep the "it's obsolete" Kconfig description. We
 > don't want new users/projects to jump on /dev/raw.

That'll just lead to some janitor sending more "OMG! OBSOLETE!" cleanup
patches getting it re-added to the feature-removal.txt
If we undeprecate it, it won't be going away, so new users of it
aren't any more of a problem than they have been the last two and
a half years.

	Dave

-- 
http://www.codemonkey.org.uk
