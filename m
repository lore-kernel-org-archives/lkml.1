Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYISUCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYISUCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYISUCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:02:16 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57824 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753925AbYISUCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:02:16 -0400
Date: Fri, 19 Sep 2008 15:02:12 -0500
From: Dean Nelson <dcn@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: [PATCH 0/3] unify the allocation of irq vectors v2
Message-ID: <20080919200212.GA6528@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset makes it so that all irq vectors are allocated via one function.

On Fri, Sep 19, 2008 at 10:48:56AM +0200, Ingo Molnar wrote:
> 
> Dean, just to make sure the useful bits are not lost now that the 
> direction has been changed: could you please repost the patchset but 
> without the driver API bits? It's still all a nice and useful 
> generalization and cleanup of the x86 vector allocation code, and we can 
> check it in -tip how well it works in practice. 

Ingo, hopefully this patchset reflects what you're looking for. Feel free
to change it anyway you like.

Thanks,
Dean
