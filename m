Return-Path: <linux-kernel-owner+w=401wt.eu-S1762437AbZBYQaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762437AbZBYQaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZBYQ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:29:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:44981 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbZBYQ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:29:52 -0500
Subject: Re: 2.6.27.14: BUG: lock held when returning to user space!
From: Peter Zijlstra <peterz@infradead.org>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Alasdair G Kergon <agk@redhat.com>
In-Reply-To: <20090225142136.GA29505@janus>
References: <20090225142136.GA29505@janus>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 17:29:49 +0100
Message-Id: <1235579389.4645.3621.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 15:21 +0100, Frank van Maarseveen wrote:
> An lvextend -L+16G command for a logical volume while being mounted rw
> as ext3 triggered the following on 2.6.27.14:
> 
> ================================================
> [ BUG: lock held when returning to user space! ]
> ------------------------------------------------
> lvextend/29191 is leaving the kernel with locks still held!
> 2 locks held by lvextend/29191:
>  #0: (&type->s_umount_key #15){....}, at: [<c019edfb>] get_super+0x6b/0xb0
>  #1: (&journal->j_barrier){....}, at: [<c01f9af3>] journal_lock_updates+0xc3/0xd0

Do recent kernels still say this?

CC'ed lvm folks.

