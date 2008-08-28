Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYH1B6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYH1B6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYH1B55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:57:57 -0400
Received: from tundra.namei.org ([65.99.196.166]:45744 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbYH1B54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:57:56 -0400
Date: Thu, 28 Aug 2008 11:57:25 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: David Howells <dhowells@redhat.com>, Andreas Gruenbacher <agruen@suse.de>,
       "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] file capabilities: Add no_file_caps switch
In-Reply-To: <20080828004807.GC16607@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0808281156110.20135@tundra.namei.org>
References: <20080827185845.GA25669@us.ibm.com> <200808262057.51606.agruen@suse.de> <200808271729.18220.agruen@suse.de> <20080827160439.GA12085@us.ibm.com> <200808271857.48651.agruen@suse.de> <31237.1219871686@redhat.com> <alpine.LRH.1.10.0808281004170.18937@tundra.namei.org>
 <20080828004807.GC16607@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Serge E. Hallyn wrote:

> Quoting James Morris (jmorris@namei.org):
> > On Wed, 27 Aug 2008, David Howells wrote:
> > 
> > >  (2) Neuter sys_capset().  I've been holding this off for the next merge
> > >      window as it isn't a bugfix, unlike (1).  Perhaps I should ask James to
> > >      push it to Linus.  James?
> > 
> > Linus only pulled the PF_SUPERPRIV fix once the sys_capset change was 
> > removed from the patch.  It really does need to be a bugfix at this stage.
> 
> Ok, sorry, of course that makes sense.  I was just confused about where
> the patch was originally heading.
> 
> Would it be appropriate to put the capset neutering patch in your
> security-testing tree, James, or does that feed straight into
> linux-next?

It's already in the next-creds branch, but it could be added to the next 
branch (which will be pushed to Linus in the next merge window).  Both 
branches are in linux-next.


-- 
James Morris
<jmorris@namei.org>
