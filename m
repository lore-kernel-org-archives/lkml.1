Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbXFDVTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbXFDVTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbXFDVTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:19:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36533 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbXFDVTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:19:35 -0400
Date: Mon, 4 Jun 2007 14:13:59 -0700
From: Greg KH <greg@kroah.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problem with http URL for stable git tree?
Message-ID: <20070604211359.GA2046@kroah.com>
References: <46646389.7090101@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46646389.7090101@am.sony.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 12:10:01PM -0700, Tim Bird wrote:
> Greg,
> 
> I'm having problems cloning the stable git tree for 2.6.21.
> Here's what I get:
> 
> $ git clone http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git stable-2.6.21.y
> Cannot get remote repository information.
> Perhaps git-update-server-info needs to be run there?

Ick, don't clone by "http://", please use the git protocol instead:
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git

that should work better.

thanks,

greg k-h
