Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYE3N6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYE3N6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYE3N6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:58:36 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51075 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYE3N6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:58:30 -0400
Date: Fri, 30 May 2008 14:58:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
In-Reply-To: <20080530102619.GA2468@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0805301451020.19914@blonde.site>
References: <20080530102619.GA2468@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Pavel Machek wrote:
> 
> sync_file_range(SYNC_FILE_RANGE_WRITE) blocks ... which makes problem
> for s2disk: there we want to start writeout as early as possible
> (system is going to shut down after write, and we need the data on
> disk).
> 
> Unfortuantely, sync_file_range(SYNC_FILE_RANGE_WRITE) blocks, which
> does not work for us. Is there non-blocking variant? "Start writeout
> on this fd, but don't block me"?

I guess there are lots of reasons why it may block (get rescheduled)
briefly, but why would that matter to you?  Are you saying that its
whole design has got broken somehow, and now SYNC_FILE_RANGE_WRITE
is behaving as if SYNC_FILE_RANGE_WAIT_AFTER had been supplied too?

Hugh
