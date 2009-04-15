Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZDOXor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZDOXor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZDOXoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:44:38 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:43779 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZDOXoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:44:37 -0400
Date: Thu, 16 Apr 2009 01:46:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       henrix@sapo.pt
Subject: Re: Trouble with make-install from a NFS mount
Message-ID: <20090415234642.GA28531@uranus.ravnborg.org>
References: <49E500F6.8060401@novell.com> <49E501D4.6000605@oracle.com> <49E627AA.5080105@novell.com> <49E641D4.2000604@oracle.com> <49E64DE1.8070909@novell.com> <20090415212009.GA27597@uranus.ravnborg.org> <49E651A9.8030409@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E651A9.8030409@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 02:29:13PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >>The problem seems to be that 30-rcX thinks that there are dependencies
> >>to update (such as include/config/kernel.release and version.h.tmp)
> >>during a make-install operation.  Since I am on a root-squashed NFS
> >>mount, these files cannot be updated and thus the install fails. 
> >>Previous trees prior to linux-current (at least up to 2.6.29) did not
> >>try to update these files so the install would succeed.
> >
> >It is because arch/x86/Makefile has
> >a dependency on vmlinux for the install target.
> >
> >I know hpa has had a fix for it but it is not applied.
> >I recall there was a trivial bug in the first version.
> >
> 
> OK, do we have a consensus that this is desirable?  I was somewhat 
> confused if it was desired or considered user error.

It is desireable - so please go ahead and fix the patch.

Thanks,
	Sam
