Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934737Ab0BZAOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:14:20 -0500
Received: from kroah.org ([198.145.64.141]:43475 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934686Ab0BZANV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:13:21 -0500
Date: Thu, 25 Feb 2010 15:28:40 -0800
From: Greg KH <greg@kroah.com>
To: Serge Hallyn <serue@us.ibm.com>
Cc: rsc@swtch.com, Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>
Subject: Re: [PATCH 1/8] p9auth: set fsuid
Message-ID: <20100225232840.GB24155@kroah.com>
References: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 04:44:54PM -0600, Serge Hallyn wrote:
> From: Serge E. Hallyn <serue@us.ibm.com>
> 
> fsuid should always trail euid changes.  So p9auth should
> set fsuid as well when it sets ruid and euid.  Whether the
> suid should also be set is an open question - keeping the
> old uid in suid may be useful, or may just serve to trick
> lazy userspace.
> 
> Note that so long as we do not also set suid, the setuid_fixup()
> code will not (when we later switch to setresuid()) fully
> fill/clear capability sets.  So while I had previously thought
> that keeping suid unchanged would be useful, I think it is
> better to change all uids.

What is your goal for the p9auth code?  Currently it is deleted in
linux-next due to a lack of development.  I see you have some cleanup
patches, but I can't apply them unless you get the non-staging patches
accepted.

If I bring the driver back from deletion, will you work to fix it up and
get it merged into mainline?

What's the word on the non-staging patches in this series being
accepted?

thanks,

greg k-h
