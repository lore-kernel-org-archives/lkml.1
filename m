Return-Path: <linux-kernel-owner+w=401wt.eu-S936700AbZDCXbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936700AbZDCXbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 19:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760156AbZDCXbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 19:31:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57094 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759992AbZDCXbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 19:31:00 -0400
Message-ID: <49D69C1D.50209@garzik.org>
Date: Fri, 03 Apr 2009 19:30:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Rees <drees76@gmail.com>
CC: Janne Grunau <j@jannau.net>, Mark Lord <lkml@rtr.ca>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090326182519.d576d703.akpm@linux-foundation.org> 	<20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> 	<alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> 	<20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> 	<49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org> <20090403212847.GC25887@aniel> 	<49D68631.4030706@garzik.org> <72dbd3150904031553r3c60a3a5k45f16e0e7513d488@mail.gmail.com>
In-Reply-To: <72dbd3150904031553r3c60a3a5k45f16e0e7513d488@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rees wrote:
> The *only* reason MythTV fsyncs (or fdatasyncs) the data to disk all
> the time is to keep a large amount of dirty pages from building up and
> then causing horrible latencies when that data starts getting flushed
> to disk.

sync_file_range() will definitely help that situation.

	Jeff


