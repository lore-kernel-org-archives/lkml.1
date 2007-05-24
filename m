Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbXEXCsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbXEXCsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 22:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbXEXCsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 22:48:47 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50837 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757391AbXEXCsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 22:48:46 -0400
Date: Wed, 23 May 2007 19:43:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0705231941230.23957@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <46540DB2.5000605@googlemail.com> <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
 <4654AC94.6080601@googlemail.com> <20070523150122.f9946f37.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
 <20070523153730.e0e9e91d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
 <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Randy Dunlap wrote:

> > > A few words in slub.txt, perhaps?
> 
> Thanks for the update.  A few nits below.

Ok will get the nits out soon.

> How large is the RedZone?  Is it a fixed size or does it vary?

The red zone are between 1 byte and a full word. If the object does not 
end at a word boundary then we fill up to the next word. If it ends on a 
word boundary then a full word of red zone bytes are inserted.


