Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYHEQ0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYHEQ0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYHEQ0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:26:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33609 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYHEQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:26:10 -0400
Subject: Re: Too many I/O controller patches
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: righi.andrea@gmail.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org
In-Reply-To: <6599ad830808042255y59215481l5463d4dca9fb2001@mail.gmail.com>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz> <489748E6.5080106@gmail.com>
	 <1217876521.20260.123.camel@nimitz> <48976A2A.9060600@gmail.com>
	 <6599ad830808042255y59215481l5463d4dca9fb2001@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 09:25:37 -0700
Message-Id: <1217953537.10907.30.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 22:55 -0700, Paul Menage wrote:
> 
> As Dave suggested, I think it would make more sense to have your
> page-dirtying throttle points hook into the memory controller instead,
> and allow the memory controller to track/limit dirty pages for a
> cgroup, and potentially do throttling as part of that.

Yeah, I'm sure we're going to have to get to setting the dirty ratio
        
        $ cat /proc/sys/vm/dirty_ratio
        40

on a per-container basis at *some* point.  We might as well do it
earlier rather than later.

-- Dave

