Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbXJUCC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbXJUCC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 22:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXJUCCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 22:02:52 -0400
Received: from namei.org ([69.55.235.186]:52720 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750838AbXJUCCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 22:02:51 -0400
Date: Sun, 21 Oct 2007 08:57:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface
In-Reply-To: <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
Message-ID: <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
 <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
 <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2007, Jan Engelhardt wrote:

> >I'd like to note that I asked people who were actually affected, and had 
> >examples of their real-world use to step forward and explain their use, 
> >and that I explicitly mentioned that this is something we can easily 
> >re-visit.
> >
> 
> I do have a pseudo LSM called "multiadm" at 
> http://freshmeat.net/p/multiadm/ , quoting:
> 

Based on Linus' criteria, this appears to be a case for reverting the 
static LSM patch.

Jan, I remember you posting this last year and IIRC, there were really 
only coding style issues to be addressed.  There were some review queries 
and suggestions (e.g. decomposing CAP_SYS_ADMIN), but no deal-breakers -- 
certainly not now that security architecture and security model objections 
are out of bounds.

So, I would suggest reposting the code for upstream inclusion, which 
would be better at least in terms of upstream maintenance, as your code 
will be visible in the tree.


- James
-- 
James Morris
<jmorris@namei.org>
