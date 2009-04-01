Return-Path: <linux-kernel-owner+w=401wt.eu-S1764547AbZDAWKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764547AbZDAWKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbZDAWKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:10:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56335 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbZDAWKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:10:43 -0400
Date: Thu, 2 Apr 2009 00:12:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: guard against jiffies wraparound on inode->dirtied_when checks (try #3)
Message-ID: <20090401221224.GW11935@one.firstfloor.org>
References: <1238607475-8203-1-git-send-email-jlayton@redhat.com> <87y6ukktu9.fsf@basil.nowhere.org> <20090401172630.31c6ac7c@tleilax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401172630.31c6ac7c@tleilax.poochiereds.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 05:26:30PM -0400, Jeff Layton wrote:
> One possibility might be a new debugging option. We could add
> replacement time_after() and time_before() macros that also check
> whether the difference in times is beyond a certain threshold
> (maybe a day or week or so), and pop a printk or otherwise record
> info about it when one is detected?

Makes sense. However it might be hard to get people to run kernels
with heavy debugging options for that long.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
