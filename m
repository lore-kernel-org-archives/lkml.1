Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZAECHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZAECHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZAECHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:07:36 -0500
Received: from tundra.namei.org ([65.99.196.166]:2857 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZAECHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:07:35 -0500
Date: Mon, 5 Jan 2009 13:07:00 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
 sys_faccessat() [ver #2]
In-Reply-To: <21275.1230736542@redhat.com>
Message-ID: <alpine.LRH.1.10.0901051301590.14359@tundra.namei.org>
References: <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008, David Howells wrote:

> 
> Here's an improved patch.  It differentiates the use of objective and
> subjective capabilities by making capable() only check current's subjective
> caps, but making has_capability() check only the objective caps of whatever
> process is specified.
> 
> It's a bit more involved, but I think it's the right thing to do.

I think it's the right approach, too, and the patch seems ok to me.  I've 
applied it to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

and expect to push it to Linus in the next day or so.  It's not a trivial 
change, and could do with more review (Serge?).

It seems that more testing should be done in linux-next vs. waiting for 
the merge window.


- James
-- 
James Morris
<jmorris@namei.org>
