Return-Path: <linux-kernel-owner+w=401wt.eu-S965398AbXBFAoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398AbXBFAoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965403AbXBFAoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:44:22 -0500
Received: from mail.suse.de ([195.135.220.2]:39333 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965397AbXBFAoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:44:20 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Date: Mon, 5 Feb 2007 16:44:01 -0800
User-Agent: KMail/1.9.5
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <20070205184410.GA20672@infradead.org>
In-Reply-To: <20070205184410.GA20672@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702051644.01701.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 10:44, Christoph Hellwig wrote:
> Just FYI:  Al was very opposed to the idea of passing the vfsmount to
> the vfs_ helpers, so you should discuss this with him.

The vfs_ helper functions are the ones calling the lsm hooks in many cases. 
Any lsm that makes pathname based decisions will need both the dentry and 
vfsmount for figuring out a file's pathname. I don't see a better way of 
passing that information to the lsm hooks than passing it through the vfs_ 
helpers.

Thanks,
Andreas
