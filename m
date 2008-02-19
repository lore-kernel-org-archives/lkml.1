Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbYBSVO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbYBSVO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYBSVOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:14:22 -0500
Received: from relay2.sgi.com ([192.48.171.30]:56502 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753422AbYBSVOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:14:21 -0500
Date: Tue, 19 Feb 2008 15:14:18 -0600
From: Paul Jackson <pj@sgi.com>
To: Jens Axboe <jens.axboe@oracle.com>, Mike Travis <travis@sgi.com>
Cc: Alan.Brunelle@hp.com, linux-kernel@vger.kernel.org, npiggin@suse.de,
       dgc@sgi.com, arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
Message-Id: <20080219151418.97557f0f.pj@sgi.com>
In-Reply-To: <20080218123717.GW23197@kernel.dk>
References: <47B0B69B.1050807@hp.com>
	<47B46008.9020804@hp.com>
	<20080218123717.GW23197@kernel.dk>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens wrote:
> My main worry with the current code is the ->lock in the per-cpu
> completion structure.

Drive-by-comment here:  Does the patch posted later this same day by Mike Travis:

  [PATCH 0/2] percpu: Optimize percpu accesses v3

help with this lock issue any?  (I have no real clue here -- just connecting
up the pretty colored dots ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
