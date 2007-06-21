Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXFUPg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXFUPg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXFUPgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:36:21 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:43982 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbXFUPgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:36:20 -0400
Date: Thu, 21 Jun 2007 08:36:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@lang.hm, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: long-term regression
Message-Id: <20070621083659.dabf3a22.randy.dunlap@oracle.com>
In-Reply-To: <20070621052807.cc64605d.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0706171052240.28371@asgard.lang.hm>
	<20070621052807.cc64605d.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007 05:28:07 -0700 Andrew Morton wrote:

> > On Sun, 17 Jun 2007 10:57:55 -0700 (PDT) david@lang.hm wrote:
> > I haven't had time to bisect this, but I'm having a problem on a AMD64 
> > gentoo system where the printer doesn't work with recent kernels.
> > 
> > 2.6.18-rc3 worked
> > 2.6.21.1 doesn't
> > 2.6.22-rc4 doesn't
> > 
> > unfortunantly the system is gooted on 2.6.18 at the moment and I'm out of 
> > town so my ability to test is limited I can provide the 2.6.22-rc4 
> > (attached) and 2.6.18-rc3 configs.
> > 
> > dmesg appears to show the port being detected, but writes to the port 
> > under newer kernels appear to complete, but no data gets to the printer.
> > 
> > any suggestions other then doing the large bisect?
> 
> That would be good, thanks.  Please be sure to cc linux-usb-devel on 
> the results.

OK, I'm curious about how someone deduced that this is a problem
with a USB printer vs. parallel port printer since the config file has:

CONFIG_PRINTER=y
CONFIG_USB_PRINTER=y

The kernel boot log should probably be posted also.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
