Return-Path: <linux-kernel-owner+w=401wt.eu-S1761267AbYHEQUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267AbYHEQUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbYHEQUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:20:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39076 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826AbYHEQU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:20:29 -0400
Subject: Re: Too many I/O controller patches
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: righi.andrea@gmail.com
Cc: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       vtaras@openvz.org, dm-devel@redhat.com, agk@sourceware.org,
       virtualization@lists.linux-foundation.org, ngupta@google.com
In-Reply-To: <48981D3B.2020701@gmail.com>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz> <489748E6.5080106@gmail.com>
	 <000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>  <48981D3B.2020701@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Aug 2008 09:20:18 -0700
Message-Id: <1217953218.10907.25.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 11:28 +0200, Andrea Righi wrote:
> > Buffered write I/O is also related with cache system.
> > We must consider this problem as I/O control.
> 
> Agree. At least, maybe we should consider if an IO controller could be
> a valid solution also for these problems.

Isn't this one of the core points that we keep going back and forth
over?  ﻿It seems like people are arguing in circles over this:

Do we:
	1. control potential memory usage by throttling I/O
or
	2. Throttle I/O when memory is full

I might lean toward (1) if we didn't already have a memory controller.
But, we have one, and it works.  Also, we *already* do (2) in the
kernel, so it would seem to graft well onto existing mechanisms that we
have.

I/O controllers should not worry about memory.  They're going to have a
hard enough time getting the I/O part right. :)

﻿Or, am I over-simplifying this?

-- Dave


