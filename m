Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0BBU6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:58:34 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36886 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab0BBU6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:58:32 -0500
Date: Tue, 2 Feb 2010 21:58:30 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: lockdep warning during elevator_switch
Message-ID: <20100202205830.GJ5733@kernel.dk>
References: <alpine.LSU.2.00.1001312327260.7190@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1001312327260.7190@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31 2010, Hugh Dickins wrote:
> From 2.6.33-rc3 onwards, PROVE_LOCKING=y gives me the warning below when
> I "echo deadline >/sys/block/sdb/queue/scheduler" to change it from cfq.
> 
> Backing out 846f99749ab68bbc7f75c74fec305de675b1a1bf "sysfs: Add lockdep
> annotations for the sysfs active reference" stops the warning -
> but I realize that doesn't mean the actual problem (if any) is fixed.

Thanks Hugh, I hadn't noticed this yet. I do online switches all the
time, but depending on tests lockdep may not be enabled (it steals all
my performance...). I'll take a look.

-- 
Jens Axboe

