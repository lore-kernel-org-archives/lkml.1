Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169Ab0BZEGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 23:06:11 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49381 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935150Ab0BZEGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 23:06:09 -0500
Date: Thu, 25 Feb 2010 22:05:53 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: rsc@swtch.com, Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com
Subject: Re: [PATCH 1/8] p9auth: set fsuid
Message-ID: <20100226040553.GA26170@us.ibm.com>
References: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
 <20100225232840.GB24155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225232840.GB24155@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
> On Tue, Feb 16, 2010 at 04:44:54PM -0600, Serge Hallyn wrote:
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > 
> > fsuid should always trail euid changes.  So p9auth should
> > set fsuid as well when it sets ruid and euid.  Whether the
> > suid should also be set is an open question - keeping the
> > old uid in suid may be useful, or may just serve to trick
> > lazy userspace.
> > 
> > Note that so long as we do not also set suid, the setuid_fixup()
> > code will not (when we later switch to setresuid()) fully
> > fill/clear capability sets.  So while I had previously thought
> > that keeping suid unchanged would be useful, I think it is
> > better to change all uids.

Hi Greg,

> What is your goal for the p9auth code?  Currently it is deleted in
> linux-next due to a lack of development.  I see you have some cleanup
> patches, but I can't apply them unless you get the non-staging patches
> accepted.

Sorry, what do you mean by 'the non-staging patches'?  Do you mean
the staging patches that were dropped, the cleanup patches (that
wouldn't make sense), or another set of patches?

> If I bring the driver back from deletion, will you work to fix it up and
> get it merged into mainline?

Yes.

> What's the word on the non-staging patches in this series being
> accepted?

Again, I'm not quite sure which you mean by the non-staging patches,
or what you mean by accepted - do you mean general community acceptance
of the base p9auth patches, or acceptance of my p9uath patches by
Ashwin etc?

thanks,
-serge
