Return-Path: <linux-kernel-owner+w=401wt.eu-S966878AbXJSVI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966878AbXJSVI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765151AbXJSVIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:08:01 -0400
Received: from namei.org ([69.55.235.186]:53696 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966813AbXJSVIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:08:00 -0400
Date: Sat, 20 Oct 2007 07:07:53 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Andreas Gruenbacher <agruen@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: LSM conversion to static interface
In-Reply-To: <200710192226.53233.agruen@suse.de>
Message-ID: <Xine.LNX.4.64.0710200631290.4442@us.intercode.com.au>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
 <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Andreas Gruenbacher wrote:

> Quoting from commit 20510f2f (Convert LSM into a static interface):
> > In a nutshell, there is no safe way to unload an LSM.  The modular interface
> > is thus unecessary and broken infrastructure.  It is used only by
> > out-of-tree modules, which are often binary-only, illegal, abusive of the
> > API and dangerous, e.g.  silently re-vectoring SELinux.
> 
> This is idiotic. Just because there is no safe way to unload SELinux
> 
>  - doesn't mean there is no safe way to unload other LSMs: if nothing
>    but that, unloading is handy during development.

Can you provide an example of a real LSM which can be safely unloaded and 
also needs to be unloaded?

Why should we maintain infrastructure and extra complexity in the kernel 
for theoretical or unknown modules ?

Linus has asked for any valid out of tree users who need a dynamic 
interface to step forward.  Where are they?

As one of the people who actually maintains LSM (rather than simply 
speculates about it), I object to maintaining infrastructure which, to the 
best of my knowledge, is only used by out of tree, binary, broken junk.

If you recall, the original motivation for this patch was when the idea 
of adding a new capability to control security model unload was raised.  

That is, new security infrastructure was being proposed merely to cater to 
some other existing unnecessary security infrastructure.  So, rather than 
doing that, I proposed removing the unnecessary infrastructure.

I agree with Linus: if you can demonstrate a valid, concrete use for 
dynamic LSMs, then the infrastructure to support them can easily be 
reinstated.

But until then, it seems both reasonable and in keeping with good kernel 
development practices, to not maintain unused infrastructure.


- James
-- 
James Morris
<jmorris@namei.org>
