Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbXGSCmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbXGSCmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 22:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbXGSCmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 22:42:14 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:56313 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbXGSCmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 22:42:13 -0400
Date: Wed, 18 Jul 2007 22:42:09 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
In-Reply-To: <20070718183503.541026f8.akpm@linux-foundation.org>
Message-ID: <Line.LNX.4.64.0707182226070.10682@d.namei>
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
 <20070718183503.541026f8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Andrew Morton wrote:

> > The SECURITY_FRAMEWORK_VERSION macro has also been removed.
> 
> I'd like to understand who is (or claims to be) adversely affected by this
> change, and what their complaints (if any) will be.
> 
> Because I prefer my flamewars pre- rather than post-merge.

This was already discussed and resolved during previous postings of the 
patch.

In a nutshell, there is no safe way to unload an LSM.  The modular 
interface is thus unecessary and broken infrastructure.  It is used only 
by out-of-tree modules, which are often binary-only, illegal, abusive of 
the API and dangerous, e.g. silently re-vectoring SELinux.

Chris has already agreed to take the patch:  
http://lkml.org/lkml/2007/6/24/152


> aww man, you passed over an opportunity to fix vast amounts of coding style
> cruftiness.

GregKH-esque :-)

> <does whizzy things>
> 
> Here you go..

Thanks.


-- 
James Morris
<jmorris@namei.org>
