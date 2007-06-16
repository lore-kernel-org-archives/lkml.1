Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbXFPWl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbXFPWl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 18:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbXFPWlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 18:41:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60178 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582AbXFPWlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 18:41:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Greaves <david@dgreaves.com>
Subject: Re: 2.6.22-rc4 XFS fails after hibernate/resume
Date: Sun, 17 Jun 2007 00:47:19 +0200
User-Agent: KMail/1.9.5
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       linux-pm <linux-pm@lists.osdl.org>
References: <46744065.6060605@dgreaves.com>
In-Reply-To: <46744065.6060605@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706170047.20559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 16 June 2007 21:56, David Greaves wrote:
> This isn't a regression.
> 
> I was seeing these problems on 2.6.21 (but 22 was in -rc so I waited to try it).
> I tried 2.6.22-rc4 (with Tejun's patches) to see if it had improved - no.
> 
> Note this is a different (desktop) machine to that involved my recent bugs.
> 
> The machine will work for days (continually powered up) without a problem and 
> then exhibits a filesystem failure within minutes of a resume.
> 
> I know xfs/raid are OK with hibernate. Is lvm?
> 
> The root filesystem is xfs on raid1 and that doesn't seem to have any problems.

What is the partition that's showing problems?  How's it set up, on how many
drives etc.?

Also, is the dmesg output below from right after the resume?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
