Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZAFWyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZAFWyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZAFWyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:54:21 -0500
Received: from tundra.namei.org ([65.99.196.166]:4759 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbZAFWyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:54:20 -0500
Date: Wed, 7 Jan 2009 09:53:48 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, bfields@citi.umich.edu
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
 sys_faccessat() [ver #3]
In-Reply-To: <5145.1231280821@redhat.com>
Message-ID: <alpine.LRH.1.10.0901070953300.29967@tundra.namei.org>
References: <alpine.LRH.1.10.0901051301590.14359@tundra.namei.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <5145.1231280821@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009, David Howells wrote:

> 
> Fix a regression in cap_capable() due to:
> 
> 	commit 3b11a1decef07c19443d24ae926982bc8ec9f4c0
> 	Author: David Howells <dhowells@redhat.com>
> 	Date:   Fri Nov 14 10:39:26 2008 +1100
> 
> 	    CRED: Differentiate objective and effective subjective credentials on a task
> 

Applied to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
