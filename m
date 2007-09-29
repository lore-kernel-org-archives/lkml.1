Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbXI2Tkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbXI2Tkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 15:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbXI2Tkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 15:40:33 -0400
Received: from emailgw02.pnl.gov ([192.101.109.34]:55771 "EHLO
	emailgw02.pnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXI2Tkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 15:40:33 -0400
X-IronPort-AV: E=Sophos;i="4.21,213,1188802800"; 
   d="scan'208";a="33387933"
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Sat, 29 Sep 2007 12:40:23 -0700
Subject: FW: [patch 01/02] vfs: variant symlinks
From: "Schmidt, Kenneth P" <kenneth.schmidt@pnl.gov>
To: Jan Dittmer <jdi@l4x.org>
CC: Al Viro <viro@ftp.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <C323F837.4E04%kenneth.schmidt@pnl.gov>
Thread-Topic: [patch 01/02] vfs: variant symlinks
Thread-Index: AcgB/IYsTK/HhodiTkeR1Um15LJY2gA045OhAAAfvaE=
In-Reply-To: <C323F762.4E00%kenneth.schmidt@pnl.gov>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2007 19:40:31.0960 (UTC) FILETIME=[98C59D80:01C802D0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/28/07 11:22 AM, "Jan Dittmer" <jdi@l4x.org> wrote:

> Ken Schmidt wrote:
>> Variant symlinks add the ability to embed variables in to the
>> contents of symbolic links so their targets can change based on
>> outside sources (user environment, uts, filesystems, etc.)
> 
> Could you elaborate why this is needed and what part cannot
> be solved in userspace (linkfarm on tmpfs or intelligent
> scripts)?

Several networked filesystems (i.e. afs) have similar concepts.  This just
moves it into the vfs layer so that it can be used on all of them and even
local filesystems.

The best example of how this can be useful is to allow a heterogeneous
environment which uses a common filesystem. For example, both x86_64 and
power systems could mount a root nfs share and execute with a common set of
configurations and data, but the binary directories (bin and lib) could
point to architecture specific directories.
