Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbZGVOzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbZGVOzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZGVOzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:55:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35168 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZGVOze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:55:34 -0400
Date: Wed, 22 Jul 2009 16:55:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: GFS2: Add LED support to GFS2
Message-ID: <20090722145534.GA6035@basil.fritz.box>
References: <1248260198.3456.4.camel@localhost.localdomain> <87k5203hdx.fsf@basil.nowhere.org> <1248274288.3298.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248274288.3298.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would be difficult to make that generic since the errors and the
> resulting actions which can be taken vary from fs to fs. The main reason
> that I didn't do it at this point in time is that the GFS2 error
> handling needs revising anyway, and once that is done (probably with an
> errors= option similar to ext2/3/4) it might be possible to think about
> LED support for that,

I was thinking to have a couple of generic functions like:

log_activity()
error_happened() 

...

that everyone could call.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
