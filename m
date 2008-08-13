Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbYHMRH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbYHMRH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYHMRHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:07:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYHMRHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:07:13 -0400
Date: Wed, 13 Aug 2008 13:07:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, andi@firstfloor.org, riel@redhat.com,
       greg@kroah.com, tytso@mit.edu, viro@ZenIV.linux.org.uk,
       arjan@infradead.org, peterz@infradead.org, hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813170708.GA17076@infradead.org>
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 05:24:37PM +0100, Alan Cox wrote:
> > So, what is it that anti-malware companies do?  They scan files.  That's
> > it. 
> 
> Good so lets instead have a discussion about making the file event
> notification more scalable. That is the same thing I want for content
> indexing. It is the same thing you want for certain kinds of smart
> archiving, for on-line asynchronous backup and other stuff.

Also for hierachial storage management, which also shares they other
requirement with the AV crowd that it want to be able to block the
calling process until the notification is ACKed (for recalling data
from offline media).

> It ought to be a simple clean syscall interface.

I was wondering whether to piggy-back on the audit code was the best
idea here..
