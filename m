Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZJZX75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZJZX75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbZJZX74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:59:56 -0400
Received: from kroah.org ([198.145.64.141]:48085 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbZJZX74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:59:56 -0400
Date: Mon, 26 Oct 2009 16:42:47 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: dream in staging: remove wakelock support
Message-ID: <20091026234247.GA26583@kroah.com>
References: <20091022090354.GA30695@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022090354.GA30695@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 11:03:54AM +0200, Pavel Machek wrote:
> 
> Includes changed so that <linux/sched.h> is now needed for
> TASK_INTERRUPTIBLE and friends, so include it.
> 
> Remove hooks for features not in mainline, such as earlysuspend and
> wakelocks.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Even after this patch, the code does not build at all.

I'm going to mark CONFIG_DREAM as BROKEN for now until the build errors
get resolved, is that fair?

thanks,

greg k-h
