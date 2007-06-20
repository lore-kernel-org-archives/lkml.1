Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbXFTCe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbXFTCe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 22:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758366AbXFTCeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 22:34:50 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:46888 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbXFTCet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 22:34:49 -0400
X-IronPort-AV: i="4.16,440,1175486400"; 
   d="scan'208"; a="32856652:sNHT25785431"
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, "Wu, Bryan" <Bryan.Wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Ungerer <gerg@snapgear.com>
In-Reply-To: <200706191926.20210.rgetz@blackfin.uclinux.org>
References: <46695F6D.5050600@t-online.de>
	 <200706191926.20210.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 20 Jun 2007 10:38:57 +0800
Message-Id: <1182307137.31771.1.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 20 Jun 2007 02:34:46.0928 (UTC) FILETIME=[915A4100:01C7B2E3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 19:26 -0400, Robin Getz wrote:
> On Fri 8 Jun 2007 09:53, Bernd Schmidt pondered:
> > Here's a patch to move nommu mmap/munmap ever so slightly closer to mmu
> > behaviour.  The motivation for this is to be able to deselect uClibc's
> > UCLIBC_UCLINUX_BROKEN_MUNMAP config option, which speeds up malloc a
> > fair bit.  I'm interested in comments whether this is a good direction
> > to go.  The patch is against Linus' tree as of a few minutes ago.
> 
> I'm assuming that since no one had any large objections, that this is OK, and 
> we should send to Andrew to live in -mm for awhile?
> 
> -Robin

Yes, IMO it is fine for kernel and uclibc. Is there any comments from
David and Greg?


Thanks
- Bryan
