Return-Path: <linux-kernel-owner+w=401wt.eu-S936818AbXGLAIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936818AbXGLAIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935831AbXGKX4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:56:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:35316 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936531AbXGKX4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:56:01 -0400
Date: Wed, 11 Jul 2007 16:55:29 -0700
From: Greg KH <gregkh@suse.de>
To: "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [PATCH 24/61] sysfs: make sysfs_put() ignore NULL sd
Message-ID: <20070711235529.GA7485@suse.de>
References: <11841968431153-git-send-email-gregkh@suse.de> <11841968471598-git-send-email-gregkh@suse.de> <11841968512510-git-send-email-gregkh@suse.de> <20070712.085047.37780825.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712.085047.37780825.yoshfuji@linux-ipv6.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 08:50:47AM +0900, YOSHIFUJI Hideaki / ?$B5HF#1QL@ wrote:
> In article <11841968512510-git-send-email-gregkh@suse.de> (at Wed, 11 Jul 2007 16:31:43 -0700), Greg Kroah-Hartman <gregkh@suse.de> says:
> 
> > Make sysfs_put() ignore NULL sd instead of oopsing.
> 
> I do not think this is a good idea; it is non-sense (and rather a bug)
> to call "put" with NULL argument in general.

It's better than having to check it all the time in the caller :)

thanks,

greg k-h
