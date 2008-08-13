Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYHMN0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYHMN0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYHMN0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:26:08 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:28435 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbYHMN0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:26:07 -0400
Date: Wed, 13 Aug 2008 07:26:06 -0600
From: Alex Chiang <achiang@hp.com>
To: David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, serue@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fixup credentials build breakage
Message-ID: <20080813132606.GA10529@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	David Howells <dhowells@redhat.com>, jmorris@namei.org,
	serue@us.ibm.com, linux-kernel@vger.kernel.org
References: <20080813053427.GA5248@ldl.fc.hp.com> <15419.1218626809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15419.1218626809@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Howells <dhowells@redhat.com>:
> Alex Chiang <achiang@hp.com> wrote:
> 
> > A recent patch titled:
> > 
> > 	CRED: Separate task security context from task_struct
> > 	
> > removed task security context from task_struct, but did not
> > update all locations to use the new struct cred that was
> > introduced.
> > 
> > The change to task_struct broke perfmon and ia32 syscalls on
> > ia64.  This patch fixes the build.
> 
> I've submitted a patch to fix this.

Thanks, clearly your patch is correct and mine was not. I was
just trying to get my build going again. I can apply yours by
hand to my own tree here to get going.

> > All things considered, I'd prefer to see this patch folded
> > into 7931c65268777ed10cab22486de149d742a1f269 so we can keep
> > bisectability. Would that be possible, given that these
> > changes are "only" in linux-next and haven't hit Linus's tree
> > yet?
> 
> Probably.  I'll have to talk to Stephen about how to do this.
> I can't maintain my patches on top of linux-next now:-/

Ok, I still think this would be a good idea, so if it's possible,
that would be great.

Thanks,

/ac

