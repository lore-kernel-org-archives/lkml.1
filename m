Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYLCXay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYLCXay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYLCXam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:30:42 -0500
Received: from tundra.namei.org ([65.99.196.166]:57790 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYLCXal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:30:41 -0500
Date: Thu, 4 Dec 2008 10:29:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com
Subject: Re: [PATCH 0/4] integrity
In-Reply-To: <20081114141813.71a0050a.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.1.10.0812041004570.4364@tundra.namei.org>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com> <20081114141813.71a0050a.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Andrew Morton wrote:

> One thing which I cannot say, and which is quite important: how useful
> will all of this be to our users?  Are people asking for it? 

Apparently, some government users are, and there's a DoD decree which 
requires new equipment to include TPM hardware where possible:

http://iase.disa.mil/policy-guidance/dod-dar-tpm-decree07-03-07.pdf

This is to support encryption of data at rest, and for "device 
authentication" (requiring remote attestation of system integrity).

It's not clear to me yet how compelling this will be for general-case 
users.

> Are
> people likely to enable and use it?  Are they even likely to understand
> it?  ;) Are any large/important customers asking for it?  Are distros
> likely to enable and support it?

I believe that TPM is in "tech preview" in RHEL 5.2, and that there is a 
desire to integrate it more fully with the OS via TCG software such as 
Trousers:  http://trousers.sourceforge.net/



- James
-- 
James Morris
<jmorris@namei.org>
