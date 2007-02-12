Return-Path: <linux-kernel-owner+w=401wt.eu-S933039AbXBLGxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbXBLGxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933048AbXBLGxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:53:10 -0500
Received: from mga06.intel.com ([134.134.136.21]:15159 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933039AbXBLGxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:53:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,312,1167638400"; 
   d="scan'208"; a="195650315:sNHT19819394"
Date: Sun, 11 Feb 2007 22:53:13 -0800
From: Valerie Henson <val_henson@linux.intel.com>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: val_henson@linux.interl.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting MS_RELATIME
Message-ID: <20070212065312.GB20919@nifty>
References: <45CE0737.6010103@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CE0737.6010103@gmx.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 09:56:07AM -0800, Michael Kerrisk wrote:
> Val,
> 
> I'm just updating the mount(2) man page for MS_RELATIME, and this is the
> text I've come up with:
> 
>        MS_RELATIME(Since Linux 2.6.20)
>               When a file on this file system is accessed, only
>               update  the  file's last accessed time (atime) if
>               the current value of atime is less than or  equal
>               to  the file's last modified (mtime) or last sta-
>               tus change time (ctime).  This option  is  useful
>               for  programs, such as mutt(1), that need to know
>               when a file has been read since it was last modi-
>               fied.
> 
> This text is based on your comments accompanying the various patches, but
> it differs in a respect.  Your comments said that the atime would only be
> updated if the atime is older than mtime/ctime.  However, what the code
> actually does is update atime if it is is <= mtime/ctime -- i.e., atime is
> older than or *or equal to* mtime/ctime.
> 
> I'm sure that the code implements your intention, but before incorporating
> the above text I thought I just better check, since the code differs from
> your comment.  Can you just confirm that the proposed man page text is okay.

That's correct, yes.  Thanks!

-VAL
