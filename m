Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab0CCIz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:55:27 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:1027 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381Ab0CCIz0 (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:1>);
	Wed, 3 Mar 2010 03:55:26 -0500
Message-Id: <4B8EBEAA0200002300014154@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 03 Mar 2010 01:55:22 -0700
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

Hi Greg, 

於 二，2010-03-02 於 15:47 -0800，Greg KH 提到：
> On Tue, Mar 02, 2010 at 11:36:16PM +0000, Matthew Garrett wrote:
> > On Tue, Mar 02, 2010 at 03:28:56PM -0800, Greg Kroah-Hartman wrote:
> > 
> > > Add threeg sysfs file for support query 3G state by standard 66/62 ec
> > > command, the MSI standard ec interface supported this feature.
> > 
> > No. Just use the rfkill interface.
> 
> Does rfkill support 3G?  I thought it was only for wireless (80211)
> stuff.
> 

M......No, rfkill have wwan type and I have also generate it in patch.
So, this patch to msi-laptop driver will gnerate the following interface
on MSI N034 netbook when netbook have 3G hardware module:
	- /sys/devices/platform/msi-laptop-pf/threeg
	- /sys/class/rfkill/rfkill2
	  	/sys/class/rfkill/rfkill2/type=wwan

I have reference acer-wmi.c then generate the threeg sysfs, and want to
follow the same style with "wlan" and "bluetooth" sysfs file
in /sys/devices/platform/msi-laptop-pf/rfkill

And, yes, userland just need control wwan by rfkill interface.
Do I need remove threeg sysfs file, now?


Thank's
Joey Lee

