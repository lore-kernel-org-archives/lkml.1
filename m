Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYHONWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYHONWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYHONWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:22:24 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:43162 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbYHONWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:22:23 -0400
In-Reply-To: <20080815131621.GK13048@mit.edu>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro	to	alinuxinterfaceforonaccess
 scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: douglas.leeder@sophos.com
Date: Fri, 15 Aug 2008 14:22:27 +0100
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 15/08/2008 14:22:22,
	Serialize complete at 15/08/2008 14:22:22
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080815132227.6BF0431678F@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

malware-list-bounces@dmesg.printk.net wrote on 2008-08-15 14:16:21:

> On Fri, Aug 15, 2008 at 08:57:48AM -0400, Press, Jonathan wrote:
> > That may just be a question of terminology.  If the bits are construed
> > not as clean/dirty/infected, but as "I care about this file" vs. "I
> > don't care about this file" then the rubber gloves come off.
> 
> Sure, as long as we're very clear about the semantics of the bits.  If
> the bits are not persistent, but which get dropped if the inode is
> every evicted from memory, and it's considered OK, or even desirable,
> to rescan the file when it is brought back into memory, that may be
> acceptable to the rubber gloves folks (make people go through lots
> superflous of security scans, even when they are transfering betewen
> flights --- security is always more important than passengers'
> convenience!), but perhaps not to other applications such as file
> indexers, who would view rescanning files that have already been
> scanned, and not have been modified, as a waste of time, battery, CPU
> and disk bandwidth, etc.
> 
> As I understand it, the TALPA proposal had non-persistent
> clean/dirty/infected bits.
> 
>                   - Ted

Yes the current proposal has temporary markers in the in-memory 
representation if inodes.

This is a problem for current anti-malware scanning, as virus data updates 
come every few hours
(at which point the entire clean/infected state has to be cleared), so the 
loss after a reboot is 
limited.

-- 
Douglas Leeder

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

