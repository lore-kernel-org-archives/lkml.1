Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZJ1XBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZJ1XBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 19:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZJ1XBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 19:01:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:35774 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZJ1XBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 19:01:32 -0400
Date: Wed, 28 Oct 2009 15:58:41 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Milan Dadok <milan@dadok.name>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH] 1/4 staging: hv: fix oops in vmbus - udev events
Message-ID: <20091028225841.GA15420@suse.de>
References: <001401ca581d$456c45e0$d044d1a0$@name>
 <8AFC7968D54FB448A30D8F38F259C5620E7EE9FF@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5620E7EE9FF@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

This is seriously annoying, and is something that the lkml mailing list
operators have said they will start blocking soon.  Please remember it.

On Wed, Oct 28, 2009 at 10:48:06PM +0000, Hank Janssen wrote:
> 
> Milan,
> 
> First of all thanks for these patches!
> 
> Greg, I do have a request though. But I am not sure what the right
> approach is. This Patch removes more than I would like. It takes out a
> few things that I would like to Keep in because I need them for prior
> versions of the kernel that we also have this Running on.

I don't understand, what in this patch is needed for older kernels?
This patch only fixes a bug that was preventing uevents from being sent
to userspace.

Also, we don't support older kernel versions in the in-kernel version of
the code, that just does not make any sense, and is why all of that old
stuff was ripped out.

> What is the suggested approach in this case. Can I submit a patch
> instead of this one That keeps some of these items still in?

Sure, what does the patch look like?

thanks,

greg k-h
