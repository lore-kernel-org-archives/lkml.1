Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZJRPwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZJRPwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 11:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZJRPwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 11:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbZJRPwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 11:52:17 -0400
Subject: Re: [BUGFIX] dnotify: handle_event shouldn't match on
 FS_EVENT_ON_CHILD
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200910181446.44625.agruen@suse.de>
References: <200910181446.44625.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Oct 2009 11:52:10 -0400
Message-Id: <1255881130.15182.99.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-18 at 14:46 +0200, Andreas Gruenbacher wrote:
> Mask off FS_EVENT_ON_CHILD in dnotify_handle_event().  Otherwise, when there
> is more than one watch on a directory and dnotify_should_send_event()
> succeeds, events with FS_EVENT_ON_CHILD set will trigger all watches and cause
> spurious events.

Added to my linus tree last night (along with a couple other fixes) will
push it public and ask him to pull when I finish testing.

-Eric

