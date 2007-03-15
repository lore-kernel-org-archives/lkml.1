Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbXCOKIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbXCOKIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbXCOKIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:08:21 -0400
Received: from main.gmane.org ([80.91.229.2]:58069 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbXCOKIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:08:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Subject: Re: [stable] [PATCH] Fix =?utf-8?b?Q09NUEFUX1ZEU08=?= regression bug
Date: Thu, 15 Mar 2007 10:08:06 +0000 (UTC)
Message-ID: <loom.20070315T110709-564@post.gmane.org>
References: <45F88780.1080507@wldelft.nl> <20070315034555.GC6842@kroah.com> <45F90796.4060104@wldelft.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 145.9.150.34 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20060601 Firefox/2.0.0.2 (Ubuntu-edgy))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Leroy van Logchem <leroy.vanlogchem <at> wldelft.nl> writes:

> 
> Greg KH wrote:
> > On Thu, Mar 15, 2007 at 12:38:40AM +0100, Leroy van Logchem wrote:
> >   
> >>     Revert "[PATCH] Fix CONFIG_COMPAT_VDSO"
> >>     This reverts commit a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f.
> >>
> >>     Several systems couldnt boot using CONFIG_HIGHMEM64G=y as
> >>     reported in bug #8040. Reverting the above patch solved the problem.
> >>     
> >
> > What stable version did you revert this in that solved your problem?
> >   
> v2.6.20.3

From: Nilshar <nilshar <at> gmail.com>
Subject: Re: [Bug 8040] Hang before INIT when CONFIG_HIGHMEM4G=y
Date: 2007-03-15 10:02:14 GMT (4 minutes ago)

Hello,

I can confirm that the problem disappear when I disable Compat VDSO
support by setting CONFIG_COMPAT_VDSO=n.



