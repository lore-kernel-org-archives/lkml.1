Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYIVUJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYIVUJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYIVUJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:09:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:38706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbYIVUJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:09:45 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: Novell, SuSE Labs
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 1/2] file capabilities: add no_file_caps switch (v2)
Date: Mon, 22 Sep 2008 22:09:35 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>
References: <20080922184835.GA2826@us.ibm.com> <1222110964.18735.77.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1222110964.18735.77.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809222209.37218.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 September 2008 21:16:04 Stephen Smalley wrote:
> On Mon, 2008-09-22 at 13:48 -0500, Serge E. Hallyn wrote:
> > (Resend of two patches from late August.  If noone objects, would it be
> > possible to see this pair take a turn in security-testing?)
> >
> > Add a no_file_caps boot option when file capabilities are
> > compiled into the kernel (CONFIG_SECURITY_FILE_CAPABILITIES=y).
>
> Is there a reason you didn't just use a filecaps=0/1 approach ala the
> selinux= boot parameter?  And let the default value be selectable as
> well?

Sure, that would work as well, except that I think that file capabilities 
should always default to "on" as they will become a standard security 
mechanism before long. We just don't have much system management tool support 
yet, and I would like to give that some more time safely, without putting 
users at unnecessary risk.

I think we could get rid of the command line option again in a year or two ...

> Seems a bit confusing to offer a no_file_caps option with different
> behavior than disabling it at build time.

I agree. These other behaviorial changes should not depend on 
CONFIG_SECURITY_FILE_CAPABILITIES; the old behavior should just be fixed 
instead.

Thanks,
Andreas
