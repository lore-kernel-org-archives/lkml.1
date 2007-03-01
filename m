Return-Path: <linux-kernel-owner+w=401wt.eu-S1030407AbXCAWIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030407AbXCAWIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030420AbXCAWIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:08:31 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45637 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030407AbXCAWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:08:30 -0500
Date: Thu, 1 Mar 2007 23:11:18 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-ID: <20070301231118.427544a4@lxorguk.ukuu.org.uk>
In-Reply-To: <45E74E30.8080909@goop.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<45E74238.3040606@goop.org>
	<20070301225855.24ecaba0@lxorguk.ukuu.org.uk>
	<45E74E30.8080909@goop.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 14:05:36 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Alan wrote:
> > A lot of people get confused about -ENOTTY, but it is the return for
> > attempting to use an ioctl on the wrong type of object, so this appears
> > to be quite correct.
> 
> This is a syscall though; ENOSYS is probably a better match.

ENOSYS indicates quite different things and ENOTTY is also used for
syscalls. I still think ENOTTY is correct.
