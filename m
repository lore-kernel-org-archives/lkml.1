Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZCQEXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZCQEXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 00:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbZCQEXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 00:23:11 -0400
Received: from kroah.org ([198.145.64.141]:53587 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750722AbZCQEXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 00:23:10 -0400
Date: Mon, 16 Mar 2009 21:22:10 -0700
From: Greg KH <greg@kroah.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #2 21/28] aufs sysfs entries
Message-ID: <20090317042210.GA17533@kroah.com>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp> <1237188040-11404-22-git-send-email-hooanon05@yahoo.co.jp> <20090316180538.GA7069@kroah.com> <7200.1237260402@jrobl> <20090317033747.GA17037@kroah.com> <7974.1237262747@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7974.1237262747@jrobl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 01:05:47PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Greg KH:
> > Which should be MAX_PATH, right?  Is that ever bigger than PAGE_SIZE?
> 
> Is the limit of PATH_MAX applied to the absolute path too?
> 
> 
> > What specifically are you trying to show here?
> 
> - the abs path of a directory which is a member of a union.
> - the abs path of a xino file which is a regular file maintained by
>   aufs.

And what do people do with this information?  Is it just debugging
stuff?  If so, please put it in debugfs, not sysfs.

thanks,

greg k-h
