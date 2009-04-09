Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbZDIVDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbZDIVDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbZDIVDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:03:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44564 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbZDIVDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:03:23 -0400
Date: Thu, 9 Apr 2009 22:03:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: register_filesystem: Don't allow '\t' and '\n'.
Message-ID: <20090409210322.GH26366@ZenIV.linux.org.uk>
References: <200904092018.GGD57377.FHJOLSMOFQOFVt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904092018.GGD57377.FHJOLSMOFQOFVt@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 08:18:20PM +0900, Tetsuo Handa wrote:
> Is it legal to use '\t' and '\n' in filesystem's name?
> If legal, we should use \ooo escape for /proc/filesystems .
> 
> ----------
> [RFC PATCH] fs: register_filesystem: Don't allow '\t' and '\n'.
> 
> Registering a filesystem with broken name
> 
>   static struct file_system_type dummy_fs_type = {
>           .name       = "a\tb\nc",
>   };
> 
> results in

... rejected patch submission.  End of problem...
