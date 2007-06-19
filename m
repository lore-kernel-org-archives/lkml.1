Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbXFSXXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbXFSXXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXFSXX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:23:29 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:20008 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbXFSXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:23:28 -0400
X-IronPort-AV: i="4.16,440,1175486400"; 
   d="scan'208"; a="42717447:sNHT31318329"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Bernd Schmidt" <bernds_cb1@t-online.de>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
Date: Tue, 19 Jun 2007 19:26:19 -0400
User-Agent: KMail/1.9.5
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>,
       "Wu, Bryan" <Bryan.Wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg Ungerer" <gerg@snapgear.com>
References: <46695F6D.5050600@t-online.de>
In-Reply-To: <46695F6D.5050600@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706191926.20210.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 19 Jun 2007 23:23:23.0606 (UTC) FILETIME=[D4C25F60:01C7B2C8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 8 Jun 2007 09:53, Bernd Schmidt pondered:
> Here's a patch to move nommu mmap/munmap ever so slightly closer to mmu
> behaviour.  The motivation for this is to be able to deselect uClibc's
> UCLIBC_UCLINUX_BROKEN_MUNMAP config option, which speeds up malloc a
> fair bit.  I'm interested in comments whether this is a good direction
> to go.  The patch is against Linus' tree as of a few minutes ago.

I'm assuming that since no one had any large objections, that this is OK, and 
we should send to Andrew to live in -mm for awhile?

-Robin
