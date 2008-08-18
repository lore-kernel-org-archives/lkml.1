Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYHRK0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYHRK0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYHRK0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:26:40 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:33681 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbYHRK0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:26:39 -0400
In-Reply-To: <48A94A55.2080309@aitel.hist.no>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: douglas.leeder@sophos.com
Date: Mon, 18 Aug 2008 11:25:41 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Douglas Leeder/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 2008-08-18 11:26:36,
	Serialize by Notes Client on Douglas Leeder/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 2008-08-18 11:26:36,
	Serialize complete at 2008-08-18 11:26:36,
	S/MIME Sign failed at 2008-08-18 11:26:36: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/08/2008 11:25:42,
	Serialize complete at 18/08/2008 11:25:42
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080818102643.C734D2FE865@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting <helge.hafting@aitel.hist.no> wrote on 2008-08-18 11:09:25:


> Scanning on open should be a last resort. Scan in advance when you can.
> Of course, removable media cannot be scanned until it is inserted and 
> mounted,
> that is obvious. The scanning can start as soon as the filesystem is 
> mounted though,
> there is no reason to wait until users try to access something.
> 
> A CD inserted into a CD-server may not necessarily be needed 
immediately, so
> scanning in advance will help here too. The user inserting a CD in a 
home
> computer may start to use stuff right away, or perhaps he spends
> some time reading the docs before a complicated install. Sill room for 
some
> scanning in advance, which also may end up with the nice effect of 
> caching the CD.

It might be useful to scan in advance, on mount, or scanner start. But 
that
can be simulated using a user-space program, and kernel-based on-open 
blocking scans:
Just have a background program open the files, and they will be scanned 
and 
cached.
The background program could also do clever things like check if running 
on battery, check
load level, keep hot-lists of files to scan/scan first.

All of which can be implemented on top of the Talpa interface already 
specified.

In practice scan on-open with blocking is fast enough for general usage, 
even using our existing 
hacky kernel module approach.

-- 
Douglas Leeder

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

