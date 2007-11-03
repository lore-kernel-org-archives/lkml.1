Return-Path: <linux-kernel-owner+w=401wt.eu-S1764494AbXKCAWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764494AbXKCAWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbXKCAWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:22:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34461 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbXKCAWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:22:09 -0400
Date: Fri, 2 Nov 2007 17:18:39 -0700
From: Greg KH <greg@kroah.com>
To: Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: basic sysfs support
Message-ID: <20071103001839.GA13530@kroah.com>
References: <20071102165331.GA16063@ionkov.net> <20071102175151.GA32460@kroah.com> <f158dc670711021214h1f9d6b80wf691fa08da1041d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f158dc670711021214h1f9d6b80wf691fa08da1041d4@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 01:14:05PM -0600, Latchesar Ionkov wrote:
> This patch adds only the basic 9p functionality, we use the sysfs
> interface extensively for configuring the 9p in-kernel servers (patch
> 7 in the series). The v9fs filesyste will probably add some more
> subdirectories for authenticating users and mapping user names to
> uids...

Ah, ok.  I don't know your projected time frame for this patch series,
but if it's for 2.6.25, you might want to look at the set of patches I
just sent to lkml to help make files like this easier to create thanks
to the great work from Kay Sievers.

thanks,

greg k-h
