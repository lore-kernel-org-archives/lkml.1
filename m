Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYLEBnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYLEBnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 20:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYLEBn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 20:43:26 -0500
Received: from tundra.namei.org ([65.99.196.166]:48895 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYLEBnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 20:43:25 -0500
Date: Fri, 5 Dec 2008 12:42:33 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: david safford <safford@watson.ibm.com>
cc: Christoph Hellwig <hch@infradead.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
In-Reply-To: <1228424014.3014.58.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0812051236420.11818@tundra.namei.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>  <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com>  <20081203123021.GA30035@infradead.org>  <1228328323.2821.30.camel@localhost.localdomain>  <20081203182300.GA31203@infradead.org>
  <1228342655.2821.64.camel@localhost.localdomain>  <20081204130949.GA18196@infradead.org> <1228424014.3014.58.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2008, david safford wrote:

> > - struct integrity_operations delcares the operations called from the
> > VFS. This one is actually used. While I don't agree to Dave's
> > argument, because we don't put bloat in just because people might
> > eventually some day use it when they are in the right mood and the
> > sun shines, thisn't isn't the one I'm talking about in this thread.
> 
> These hooks were for alternate integrity modules, and since
> no one else has defended them, we have to agree that they
> should be replaced with direct calls.

If you know of other modules which are planned to be ported to this 
framework, merged upstream and supported, then this would be similar to 
the situation when LSM was initially developed.

You've previously mentioned some active projects here:
http://lkml.org/lkml/2008/11/17/362

Are there any definite committments to push these upstream when the 
integrity framework is merged?


- James
-- 
James Morris
<jmorris@namei.org>
