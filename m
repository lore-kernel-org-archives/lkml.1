Return-Path: <linux-kernel-owner+w=401wt.eu-S1762737AbXGTMWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762737AbXGTMWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbXGTMWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:22:21 -0400
Received: from [212.12.190.219] ([212.12.190.219]:33120 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755534AbXGTMWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:22:20 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-raid@vger.kernel.org
Subject: Re: [RFH] Partition table recovery
Date: Fri, 20 Jul 2007 15:22:17 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200707200813.03553.a1426z@gawab.com> <200707201429.34419.a1426z@gawab.com> <20070720113914.GJ22998@lug-owl.de>
In-Reply-To: <20070720113914.GJ22998@lug-owl.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201522.17270.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Benedict Glaw wrote:
> On Fri, 2007-07-20 14:29:34 +0300, Al Boldi <a1426z@gawab.com> wrote:
> > But, I want something much more automated.  And the partition table
> > backup per partition entry isn't really a bad idea.
>
> That's called `gpart'.

Oh, gpart is great, but if we had a backup copy of the partition table on 
every partition location on disk, then this backup copy could easily be 
reused to reconstruct the original partition table without further 
searching.  Just like the NetWare approach, and in some respect like the 
ext2/3 superblock backups.


Thanks!

--
Al

