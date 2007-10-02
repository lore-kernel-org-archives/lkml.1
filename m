Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbXJBIgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbXJBIgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXJBIgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:36:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:47076 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752539AbXJBIgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:36:44 -0400
X-Authenticated: #2253541
X-Provags-ID: V01U2FsdGVkX19pBZAOQXFp2ZLw5yY4ewY3fIJhxuBXyXBvLcSzz3
	W6MltRhwdwVfuj
Date: Tue, 2 Oct 2007 10:36:32 +0200
From: Thomas Bleher <ThomasBleher@gmx.de>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory
	Access Control Kernel
Message-ID: <20071002083631.GA7101@thomas>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
	torvalds@linux-foundation.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Kleen <ak@suse.de>, James Morris <jmorris@namei.org>,
	Paul Moore <paul.moore@hp.com>
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org> <20070930095310.GA18642@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070930095310.GA18642@infradead.org>
X-Accept-Language: de, en
X-Operating-System: Linux 2.6.23-rc8-gff0ce684 x86_64
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig <hch@infradead.org> [2007-10-02 10:14]:
> On Sun, Sep 30, 2007 at 01:16:18AM -0700, Andrew Morton wrote:
> > reviewed the August thread from your version 1 submission and the message I
> > take away is that the code has been well-received and looks good when
> > considered on its own merits, but selinux could probably be configured to
> > do something sufficiently similar.
> > 
> > I'd have trouble declaring that "but" to be a reason to not merge smack.
> > I'm more thinking "let's merge it and see if people use it".
> 
> I'm not sure this was discussed on the list, but as long as Casey doesn't
> get rid of the magic symlinks (smackfs_follow_link), there's a clear NACK
> from the VFS perspective.

Any rationale for this NACK?
Caseys patch doesn't add something crazy like "make symlinks depend on
environment variables"; also, we already have something similar in-tree:
/proc/self.

Thomas
