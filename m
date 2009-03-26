Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbZCZN23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbZCZN23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZCZN1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:27:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49286 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZCZN1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:27:49 -0400
Date: Thu, 26 Mar 2009 08:27:38 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Willy Tarreau <w@1wt.eu>
Cc: mtk.manpages@gmail.com, Stephen Smalley <sds@epoch.ncsc.mil>,
       Andrew Morgan <morgan@kernel.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Igor Zhbanov <izh1979@gmail.com>, stable@kernel.org,
       linux-api@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2.4] CAP_FS_MASK: add CAP_LINUX_IMMUTABLE and CAP_MKNOD
Message-ID: <20090326132738.GB13639@us.ibm.com>
References: <20090325173954.GA19299@us.ibm.com> <20090326052958.GC13146@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326052958.GC13146@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Willy Tarreau (w@1wt.eu):
> Hello,
> 
> On Wed, Mar 25, 2009 at 12:39:54PM -0500, Serge E. Hallyn wrote:
> > When POSIX capabilities were introduced during the 2.1 Linux
> > cycle, the fs mask, which represents the capabilities which having
> > fsuid==0 is supposed to grant, did not include CAP_MKNOD and
> > CAP_LINUX_IMMUTABLE.  However, before capabilities the privilege
> > to call these did in fact depend upon fsuid==0.
> > 
> > This patch introduces those capabilities into the fsmask,
> > restoring the old behavior.
> > 
> > See the thread starting at http://lkml.org/lkml/2009/3/11/157 for
> > reference.
> 
> Thanks to Igor and you for fixing this. The impact did not appear
> obvious to me at first, to be honnest! I'm queuing the patch for
> next release.
> 
> BTW, I've noticed your other patch for 2.2.26, but it's not worth
> wasting time on it, as 2.2 has remained unmaintained for years now
> and people are really discouraged from using it as many holes have
> never been fixed there.
> 
> Cheers,
> Willy

Sounds good to me.

thanks,
-serge
