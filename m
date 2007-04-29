Return-Path: <linux-kernel-owner+w=401wt.eu-S1031393AbXD2Utb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031393AbXD2Utb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031431AbXD2Utb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:49:31 -0400
Received: from rtr.ca ([64.26.128.89]:1587 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031393AbXD2Ut3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:49:29 -0400
Message-ID: <463504D7.7040002@rtr.ca>
Date: Sun, 29 Apr 2007 16:49:27 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Lee Revell <rlrevell@joe-job.com>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
References: <1177660767.6567.41.camel@Homer.simpson.net>	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>	 <Pine.LNX.4.64.0704282242280.16099@artax.karlin.mff.cuni.cz> <75b66ecd0704281412x33352e97kc9c646ea594ef9ee@mail.gmail.com>
In-Reply-To: <75b66ecd0704281412x33352e97kc9c646ea594ef9ee@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:
> On 4/28/07, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:
>> I most wonder, why vim fsyncs its swapfile regularly (blocking typing
>> during that) and doesn't fsync the resulting file on :w  :-/
> 
> Never seen this.  Why would fsync block typing unless vim was doing
> disk IO for every keystroke?

It does do that, for the crash-recovery files it maintains.
