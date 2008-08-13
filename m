Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYHMQsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYHMQsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYHMQsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:48:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbYHMQsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:48:02 -0400
Subject: Re: TALPA - a threat model?  well sorta.
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, arjan@infradead.org, peterz@infradead.org,
       hch@infradead.org
In-Reply-To: <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
References: <1218645375.3540.71.camel@localhost.localdomain>
	 <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 12:47:45 -0400
Message-Id: <1218646065.3540.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 17:24 +0100, Alan Cox wrote:
> > So, what is it that anti-malware companies do?  They scan files.  That's
> > it. 
> 
> Good so lets instead have a discussion about making the file event
> notification more scalable. That is the same thing I want for content
> indexing. It is the same thing you want for certain kinds of smart
> archiving, for on-line asynchronous backup and other stuff.
> 
> It ought to be a simple clean syscall interface.

Are you willing to make it blocking?  I'm not sure how to make what we
have capable of assuring that the object you got a notification about is
actually the object you are acting on.  Thoughts on how to accomplish
that?  I'm here to code and I'm willing to throw all my work in the
garbage if someone can show me how to actually do it better.

-Eric

