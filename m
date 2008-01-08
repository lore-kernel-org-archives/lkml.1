Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYAHVXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYAHVXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYAHVX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:23:26 -0500
Received: from [212.12.190.54] ([212.12.190.54]:56137 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753033AbYAHVXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:23:25 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-fsdevel@vger.kernel.org
Subject: [RFD] Incremental fsck
Date: Wed, 9 Jan 2008 00:22:55 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801090022.55589.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Theodore Tso <tytso@mit.edu> writes:
> > Now, there are good reasons for doing periodic checks every N mounts
> > and after M months.  And it has to do with PC class hardware.  (Ted's
> > aphorism: "PC class hardware is cr*p").
>
> If these reasons are good ones (some skepticism here) then the correct
> way to really handle this would be to do regular background scrubbing
> during runtime; ideally with metadata checksums so that you can actually
> detect all corruption.
>
> But since fsck is so slow and disks are so big this whole thing
> is a ticking time bomb now. e.g. it is not uncommon to require tens
> of minutes or even hours of fsck time and some server that reboots
> only every few months will eat that when it happens to reboot.
> This means you get a quite long downtime.

Has there been some thought about an incremental fsck?

You know, somehow fencing a sub-dir to do an online fsck?


Thanks for some thoughts!

--
Al

