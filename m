Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839Ab0A2WZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0A2WZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233Ab0A2WZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:25:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48608 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0A2WZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:25:43 -0500
Date: Fri, 29 Jan 2010 22:25:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 06/10] affs: Convert semaphores to mutexes
Message-ID: <20100129222541.GB31305@ZenIV.linux.org.uk>
References: <20100129203549.526478432@linutronix.de>
 <20100129203613.591137914@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129203613.591137914@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 08:38:55PM -0000, Thomas Gleixner wrote:
> These semaphores are plain mutexes. Convert them to struct mutex.
> 
> Map affs_[un]lock_dir() to affs_[un]lock_ext() instead of the "#define
> i_hash_lock i_ext_lock" magic.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>

Umm...  I'm not ready to sign off on that one without serious analysis;
there might be dragons.
