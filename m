Return-Path: <linux-kernel-owner+w=401wt.eu-S934948AbZARScW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934948AbZARScW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934180AbZARScL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:32:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934153AbZARScL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:32:11 -0500
Date: Sun, 18 Jan 2009 10:22:21 -0800
From: Greg KH <gregkh@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: arve@android.com, jrm8005@gmail.com, rlove@google.com, swetland@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] android: task_get_unused_fd_flags: fix the wrong usage
	of tsk->signal
Message-ID: <20090118182221.GA14477@suse.de>
References: <20090118171720.GA18374@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118171720.GA18374@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 06:17:20PM +0100, Oleg Nesterov wrote:
> Compile tested.
> 
> task_struct->signal is not protected by RCU, the code is bogus.
> Change the code to take ->siglock to pin ->signal.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Thanks for the fix, I'll queue it up next week.

greg k-h
