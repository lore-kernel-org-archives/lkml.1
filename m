Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYAFQ4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYAFQ4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYAFQ4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:56:42 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57335 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbYAFQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:56:42 -0500
Date: Sun, 6 Jan 2008 09:56:40 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, James.Bottomley@HansenPartnership.com
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080106165640.GL20473@parisc-linux.org>
References: <4780DDBB.7090807@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4780DDBB.7090807@m3y3r.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 02:55:07PM +0100, Thomas Meyer wrote:
> This is the correct setup to trigger the bug. And the commit
> 6f5391c283d7fdcf24bf40786ea79061919d1e1d has nothing to do with this
> bug. It was bad luck that i couldn't trigger the bug with said commit
> reverted (in my tests, the second boot with the reverted commit missed
> the first mount/umount smaller cd step, so...)

Great.  Linus, can you revert the revert now?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
