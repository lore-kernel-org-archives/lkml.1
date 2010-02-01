Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0BAG1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 01:27:38 -0500
Received: from 1wt.eu ([62.212.114.60]:56037 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab0BAG1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 01:27:37 -0500
Date: Mon, 1 Feb 2010 07:27:29 +0100
From: Willy Tarreau <w@1wt.eu>
To: Justin Madru <jdm64@gawab.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Forward porting 2.4 driver
Message-ID: <20100201062729.GC27453@1wt.eu>
References: <4B634540.9070306@gawab.com> <20100129203613.GF27907@1wt.eu> <4B665322.2060005@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B665322.2060005@gawab.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 31, 2010 at 08:05:54PM -0800, Justin Madru wrote:
> Well, it's good that the driver might easily be updated to the latest 2.4.
> 
> I did a diff of the source code that was provided against 2.6.30. 
> Unfortunately, it looks like there's been more changes to the code than 
> simply adding drivers. Updates all across the tree have been made, some 
> minor that would be an easy merge. But some seem to be more involved 
> changes. Any suggestions on merging the code?
 
Then I'd suggest that you progressively apply all 2.4 versions one by
one on top of their code. You should have less changes that way and
since you'll have changelogs, you'll be able to tell what the changes
want to do and whether you have to merge them or you can ignore them.
Once you reach 2.4.32, you can even choose to apply all patches one
at a time because the kernel migrated to use GIT. There are "only"
608 patches. Those are quickly reviewed to eliminate the arch-specific
ones you don't care about and only keep generic fixes.

Well that's just an idea. Also, keep a copy of intermediate versions
(or ideally put them into a git tree starting at plain 2.4.30).

Hoping this helps,
Willy

