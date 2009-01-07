Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZAGAKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZAGAKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZAGAKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:10:00 -0500
Received: from tundra.namei.org ([65.99.196.166]:3480 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbZAGAJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:09:59 -0500
Date: Wed, 7 Jan 2009 11:09:21 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
 sys_faccessat() [ver #3]
In-Reply-To: <20090106235734.GG13785@fieldses.org>
Message-ID: <alpine.LRH.1.10.0901071109010.30837@tundra.namei.org>
References: <alpine.LRH.1.10.0901051301590.14359@tundra.namei.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <5145.1231280821@redhat.com> <alpine.LRH.1.10.0901070953300.29967@tundra.namei.org>
 <20090106235734.GG13785@fieldses.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009, J. Bruce Fields wrote:

> On Wed, Jan 07, 2009 at 09:53:48AM +1100, James Morris wrote:
> > On Tue, 6 Jan 2009, David Howells wrote:
> > 
> > > 
> > > Fix a regression in cap_capable() due to:
> > > 
> > > 	commit 3b11a1decef07c19443d24ae926982bc8ec9f4c0
> > > 	Author: David Howells <dhowells@redhat.com>
> > > 	Date:   Fri Nov 14 10:39:26 2008 +1100
> > > 
> > > 	    CRED: Differentiate objective and effective subjective credentials on a task
> > > 
> > 
> > Applied to:
> > git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> 
> Thanks!  When should that be in mainline?

As soon as Linus pulls.

-- 
James Morris
<jmorris@namei.org>
