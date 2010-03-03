Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0CCPZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:25:41 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:9150 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327Ab0CCPZk (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:1>);
	Wed, 3 Mar 2010 10:25:40 -0500
Message-Id: <4B8F1A220200002300014185@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 03 Mar 2010 08:25:38 -0700
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <mzxreary@0pointer.de>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 57/62] msi-laptop: Add threeg sysfs file for
	 support query 3G state by standard 66/62 ec command
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

於 三，2010-03-03 於 13:46 +0000，Matthew Garrett 提到：
> On Tue, Mar 02, 2010 at 03:47:00PM -0800, Greg KH wrote:
> > On Tue, Mar 02, 2010 at 11:36:16PM +0000, Matthew Garrett wrote:
> > > On Tue, Mar 02, 2010 at 03:28:56PM -0800, Greg Kroah-Hartman wrote:
> > > 
> > > > Add threeg sysfs file for support query 3G state by standard 66/62 ec
> > > > command, the MSI standard ec interface supported this feature.
> > > 
> > > No. Just use the rfkill interface.
> > 
> > Does rfkill support 3G?  I thought it was only for wireless (80211)
> > stuff.
> 
> rfkill has types for the majority of radios. A later patch adds the 3g 
> rfkill device, so this one should just be dropped - there's no reason to 
> add a non-standard radio control file now.
> 

So, "wwan" does not mean "3g"? or 3g is included in "wwan"?
And, does the "non-standard radio control file" mean like "threeg",
"wlan" or "bluetooth" in /sys/devices/platform/xxxxx ?

In current x86/platform, there have a bit driver still used the
"non-standard control file". Does that mean we need replace all of 
those control files by rfkill interface?


Thank's
Joey Lee

