Return-Path: <linux-kernel-owner+w=401wt.eu-S1762025AbYHERcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025AbYHERcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbYHERcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:32:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4318 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760121AbYHERcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:32:23 -0400
Date: Tue, 5 Aug 2008 19:32:09 +0200
From: Pavel Machek <pavel@suse.cz>
To: david safford <safford@watson.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
Message-ID: <20080805173208.GA8380@ucw.cz>
References: <1211555145.16195.18.camel@new-host> <20080528012242.a0e98d87.akpm@linux-foundation.org> <1214324930.3262.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214324930.3262.94.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-06-24 12:28:50, david safford wrote:
> On Wed, 2008-05-28 at 01:22 -0700, Andrew Morton wrote:
> 
> > - I see lots of user file I/O being done from within the kernel. 
> >   This makes eyebrows raise.  Also some other eyebrow-raising
> >   file-related things in there.
> > 
> > Generally: the code is all moderately intrusive into the VFS and this
> > sort of thing does need careful explanation and justification, please. 
> > Once we have some understanding of what you're trying to achieve here
> > we will inevitably ask "can't that be done in userspace".  So it would
> > be best if your description were to preemptively answer all that.  
> > 
> > 
> Sorry about this delayed response - we are about to repost for RFC, and
> noticed we missed responding to this.
> 
> The Trusted Computing (TPM) model requires that all files be measured,
> (hashed) and the measurement committed to the hardware TPM before any
> data of the file is accessed in any way. In addition, if the measurement
> is incorrect, all access to the file must be denied. 

TPM model may require this, but what is the benefit to the user/owner
of the machine?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
