Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYJEDWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYJEDWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 23:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYJEDWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 23:22:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:34572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbYJEDWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 23:22:07 -0400
Message-ID: <48E83272.7040709@kernel.org>
Date: Sun, 05 Oct 2008 12:20:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, pchen@nvidia.com, stable@kernel.org
Subject: Re: patch sata_nv-disable-hardreset-for-generic.patch added to	2.6.26-stable
 tree
References: <20081001234424.C72C114543E5@imap.suse.de> <200810041827.04721.s.L-H@gmx.de> <20081005025401.GA22549@suse.de>
In-Reply-To: <20081005025401.GA22549@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 05 Oct 2008 03:21:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>>> From 2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6 Mon Sep 17 00:00:00 2001
>>> From: Tejun Heo <tj@kernel.org>
>>> Date: Fri, 29 Aug 2008 16:13:12 +0200
>>> Subject: sata_nv: disable hardreset for generic
>>>
>>> From: Tejun Heo <tj@kernel.org>
>>>
>>> commit 2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6 upstream
>>>
>>> of them being unifying probing, hotplug and EH reset paths uniform.
>>> Previously, broken hardreset could go unnoticed as it wasn't used
>>> during probing but when something goes wrong or after hotplug the
>>> problem will surface and bite hard.
>>>
>>> OSDL bug 11195 reports that sata_nv generic flavor falls into this
>>> category.  Hardreset itself succeeds but PHY stays offline after
>>> hardreset.  I tried longer debounce timing but the result was the
>>> same.
>>>
>>>   http://bugzilla.kernel.org/show_bug.cgi?id=11195
>>>
>>> So, it seems we'll have to drop hardreset from the generic flavor.
>>>
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>> Cc: Peer Chen <pchen@nvidia.com>
>>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>> On 2.6.26.5 + the pending stable queue applied, this patch results in lots 
>> of noise in my syslog (full gzipped dmesg with and without this patch 
>> attached):
> 
> This patch has been removed from the stable queue, so it shouldn't be an
> issue anymore, right?

It's currently a mess.  Please take a look at the following message for
the whole story.

  http://article.gmane.org/gmane.linux.ide/34942

It's interesting how they fixed hardreset of the chipset step-by-step. :-(

Thanks.

-- 
tejun
