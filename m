Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYCSXTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYCSXTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938545AbYCSVql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:46:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:47839 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938549AbYCSVqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:46:40 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: Linux 2.6.25-rc4
Date: Tue, 18 Mar 2008 15:48:25 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803181403.37969.bzolnier@gmail.com> <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org>
In-Reply-To: <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803181548.25241.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2008, Anders Eriksson wrote:
> 
> bzolnier@gmail.com said:
> > Could you also add printk() to task_in_intr()? 
> 
> Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
> Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
> Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
> Mar 18 14:18:26 tippex task_in_intr: hda: stat=50

This is quite unexpected status value...

Please add "#define DEBUG" before ide_tf_load() in ide-taskfile.c
so we can see which SMART sub-command is causing this.

Thanks,
Bart
