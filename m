Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZIGHoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZIGHoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZIGHoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:44:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:44882 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZIGHo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:44:29 -0400
Date: Mon, 7 Sep 2009 09:44:31 +0200
From: Nick Piggin <npiggin@suse.de>
To: Eric Paris <eparis@parisplace.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 09/33] fs: dcache scale dentry refcount
Message-ID: <20090907074431.GH1875@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net> <20090904065535.281876981@nick.local0.net> <7e0fb38c0909061101t6b4f337cvf691814c28bcf50e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e0fb38c0909061101t6b4f337cvf691814c28bcf50e@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 06, 2009 at 02:01:05PM -0400, Eric Paris wrote:
> On Fri, Sep 4, 2009 at 2:51 AM, <npiggin@suse.de> wrote:
> 
> And yet in this case we do check for dentry->d_parent == dentry.  (my
> unknowing self thinks we'd want to check in all places)

I think you're right, I think we need checks there too...

BTW Is there a way to test the fsnotify code? I thought inotify was
supposed to be implemented with fsnotify, but I see quite a lot
of duplicated (or very similar) code... We've also still got
inotify calls in fs/ (inotify_umount_inodes). and CONFIG_INOTIFY and
CONFIG_FSNOTIFY conditionals in there too. Would it be possible to
move that out into fsnotify calls? (fsnotify_inode_init_once or
whatever).

(Sorry to hijack your good review comments :))

Thanks,
Nick

