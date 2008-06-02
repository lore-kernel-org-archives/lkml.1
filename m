Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYFBMLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYFBMLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYFBMLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:11:00 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:57206 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYFBMK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:10:59 -0400
Date: Mon, 2 Jun 2008 13:11:00 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       mtk.manpages@gmail.com, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
In-Reply-To: <200806021318.26404.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0806021305550.11775@blonde.site>
References: <Pine.LNX.4.64.0805301451020.19914@blonde.site>
 <20080601161133.ea344adf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0806020906001.9534@blonde.site> <200806021318.26404.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Rafael J. Wysocki wrote:
> 
> Well, frankly, I'm not sure if we need anything better than we already have.
> In fact my numbers show that SYNC_FILE_RANGE_WRITE works quite well -
> please see
> http://sourceforge.net/mailarchive/message.php?msg_name=200806020122.36193.rjw%40sisk.pl
> "early writeout" means that SYNC_FILE_RANGE_WRITE is used and the file with
> the results is attached for convenience.
> 
> My interpretation of the results is here:
> http://sourceforge.net/mailarchive/forum.php?thread_name=200806021238.17100.rjw%40sisk.pl&forum_name=suspend-devel

If the current SYNC_FILE_RANGE_WRITE is good enough for you, great,
keep on using it.  Forgive me, I'm not much concerned with your
particular use, I'll happily leave that to you and Pavel!  What
bothers me is Pavel's discovery that a WAIT|WRITE|WAIT interface,
designed to help callers by allowing those stages to be separated,
ends up doing a significant amount of WAITing in the WRITE stage.

Hugh
