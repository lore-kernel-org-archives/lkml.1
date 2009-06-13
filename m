Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbZFMGQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbZFMGQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZFMGP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:15:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:58482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFMGP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:15:56 -0400
Date: Fri, 12 Jun 2009 23:16:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: IO latency - a special case
Message-ID: <20090612231627.1222f526@infradead.org>
In-Reply-To: <9b1675090906122251y43476b23wd3593927e3b792c2@mail.gmail.com>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
	<9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com>
	<9b1675090904042125g708076e6v665f5ecc7fa020a4@mail.gmail.com>
	<9b1675090904042313rb8178b6v1da3aeddfa57a869@mail.gmail.com>
	<20090405062626.GA7760@mit.edu>
	<9b1675090904051542o42a0ca11y1ce3b691ed6d8ebb@mail.gmail.com>
	<9b1675090906062014h2ce44d8apc50f73aa036d9139@mail.gmail.com>
	<20090611191152.GD16787@mit.edu>
	<9b1675090906122048o35698c09x13cc7cf7650ac9ae@mail.gmail.com>
	<20090612212414.1ae5a284@infradead.org>
	<9b1675090906122251y43476b23wd3593927e3b792c2@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 23:51:19 -0600
"Trenton D. Adams" <trenton.d.adams@gmail.com> wrote:
> 
> Right now, just during normal system usage, it's showing...
> Cause                                                Maximum
> Percentage poll_schedule_timeout do_sys_poll sys_poll sysente  5.0
> msec         58.0 % futex_wait do_futex compat_sys_futex
> sysenter_disp  5.0 msec         40.3 % blk_execute_rq scsi_execute
> scsi_execute_req scsi_  3.9 msec          0.2 % blk_execute_rq
> scsi_execute scsi_execute_req sd_re  3.5 msec          0.2 %
> poll_schedule_timeout do_select core_sys_select sy  3.4 msec
> 0.3 % blk_execute_rq scsi_execute scsi_execute_req sr_te  2.6
> msec          0.5 % blk_execute_rq scsi_execute scsi_execute_req
> sr_te  2.2 msec          0.5 % blk_execute_rq scsi_execute
> sr_do_ioctl sr_packet   0.9 msec          0.1 % blk_execute_rq
> scsi_execute scsi_execute_req ioctl  0.6 msec          0.0 % release
> __blkdev_put blkdev_put blkdev_close __fput

this shows it's not correctly installed....

(and it's likely an older version)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
