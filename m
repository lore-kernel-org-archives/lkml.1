Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZIEN1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZIEN1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 09:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZIEN1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 09:27:05 -0400
Received: from mail2.shareable.org ([80.68.89.115]:35423 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZIEN1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 09:27:03 -0400
Date: Sat, 5 Sep 2009 14:26:53 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090905132653.GH24516@shareable.org>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-9-git-send-email-jens.axboe@oracle.com> <4AA13232.5000309@rsk.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA13232.5000309@rsk.demon.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy wrote:
> I've been testing this & it works pretty well here, but setting 
> max_writeback_mb to 128 seems much too large for normal desktop machines.
> 
> Because it is so large the background writes don't stop when they get 
> down to the background threshold, but just keep on writing. 
> background_threshold on my machine is only about 300Mb so it can 
> undershoot by quite a bit. This could impact random write workloads 
> significantly.

If that's true, would it be even worse for embedded devices with, say,
just 32MB RAM?  It sounds like writeback undershoot might be rather
extreme in that case.

Also on this topic, should max_writeback be smaller for slow disks?  I
have a small device here with a hard disk that can only be written at
2-10MB/s due to limitations of the built-in IDE controller.

I know that's unusual, but it shows there is quite a wide range of
speeds at which disks can be written, even just counting hard disks.

-- Jamie
