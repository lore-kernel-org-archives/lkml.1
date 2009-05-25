Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZEYP5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZEYP5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZEYP5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:57:23 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:57799 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbZEYP5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:57:23 -0400
Message-ID: <4A1ABFE2.9050809@rsk.demon.co.uk>
Date: Mon, 25 May 2009 16:57:22 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I've been testing this from your git version which builds as
2.6.30-rc6-00057-g81eabcf.

Unfortunately it's not doing too well.

When building a kernel with 'make -j 8' on my AMDX2 64bit, the screen
repeatedly locked up for several minutes at a time,and my music player
also froze.
In total the full kernel build took over 80 minutes, normally it's only
about 15.

However the machine seems to have recovered correctly, & now everything
is back to normal.

Maybe it does need the congestion handling after all?

regards
Richard



