Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYH1AsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYH1AsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYH1AsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:48:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46124 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYH1AsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:48:09 -0400
Date: Wed, 27 Aug 2008 19:48:08 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, Andreas Gruenbacher <agruen@suse.de>,
       "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] file capabilities: Add no_file_caps switch
Message-ID: <20080828004807.GC16607@us.ibm.com>
References: <20080827185845.GA25669@us.ibm.com> <200808262057.51606.agruen@suse.de> <200808271729.18220.agruen@suse.de> <20080827160439.GA12085@us.ibm.com> <200808271857.48651.agruen@suse.de> <31237.1219871686@redhat.com> <alpine.LRH.1.10.0808281004170.18937@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0808281004170.18937@tundra.namei.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Wed, 27 Aug 2008, David Howells wrote:
> 
> >  (2) Neuter sys_capset().  I've been holding this off for the next merge
> >      window as it isn't a bugfix, unlike (1).  Perhaps I should ask James to
> >      push it to Linus.  James?
> 
> Linus only pulled the PF_SUPERPRIV fix once the sys_capset change was 
> removed from the patch.  It really does need to be a bugfix at this stage.

Ok, sorry, of course that makes sense.  I was just confused about where
the patch was originally heading.

Would it be appropriate to put the capset neutering patch in your
security-testing tree, James, or does that feed straight into
linux-next?

thanks,
-serge
