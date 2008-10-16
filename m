Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYJPRlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYJPRlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYJPRlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:41:13 -0400
Received: from kroah.org ([198.145.64.141]:33447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752744AbYJPRlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:41:12 -0400
Date: Thu, 16 Oct 2008 10:35:29 -0700
From: Greg KH <greg@kroah.com>
To: Tim Shimmin <tes@sgi.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [stable] [PATCH] XFS fix remount rw with unrecognized options
Message-ID: <20081016173529.GA13038@kroah.com>
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016002926.D912558FA22B@chook.melbourne.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 11:29:26AM +1100, Tim Shimmin wrote:
> Resending as I mangled sending the mail from home last time. Sorry.
> 
> Please include the following patch for 2.6.27.1 stable release as
> suggested by Christoph Hellwig and Eric Sandeen.
> It fixes a regression in the recent remount recoding
> where remounting say from ro to rw allows the xfs flags to
> be out of sync with the vfs flags, resulting
> in failures for some programs such as touch (which end up calling xfs_setattr).
> The fix is a very minor and clear.

Is this patch already in Linus's tree?  If so, do you have a git commit
id?

thanks,

greg k-h
