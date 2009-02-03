Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZBCWYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZBCWYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZBCWYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:24:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZBCWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:24:10 -0500
Date: Tue, 3 Feb 2009 14:21:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
Subject: Re: [PATCH V4] Allow SysRq emergency thaw to thaw frozen
 filesystems
Message-Id: <20090203142118.ed4d8e3e.akpm@linux-foundation.org>
In-Reply-To: <4988C00A.2040904@redhat.com>
References: <496EB639.6090800@redhat.com>
	<4970E087.8020308@redhat.com>
	<4970E4FB.7040407@redhat.com>
	<20090130134009.02d4a576.akpm@linux-foundation.org>
	<498779D6.7010304@redhat.com>
	<20090203140135.fe8360f6.akpm@linux-foundation.org>
	<4988C00A.2040904@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Feb 2009 16:07:06 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> Andrew Morton wrote:
> > On Mon, 02 Feb 2009 16:55:18 -0600
> > Eric Sandeen <sandeen@redhat.com> wrote:
> > 
> >> (this version fixes a couple small issues raised by Randy Dunlap)
> >> (and adds sb_lock locking I forgot, as akpm pointed out)
> >> (Randy's CONFIG_BLOCK fix should still apply over this)
> > 
> > <converts it to a delta so I can see what you did>
> 
> Sorry, didn't know if you want deltas on top of old patches or new
> respun patches.  Guess now I know :)

There's no easy answer.  For new reviewers/testers, the whole patch is better.

But for people who reviewed/tested the earlier patch, the delta is
better.

So a replacement patch is usually OK.  I will turn it into a delta with
a flick of the wrist and those people who I cc'ed on the patch (and
mm-commits subscribers) will get to see the delta.

