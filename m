Return-Path: <linux-kernel-owner+w=401wt.eu-S1759890AbXEKKoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbXEKKoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 06:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbXEKKoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 06:44:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57356 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756315AbXEKKob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 06:44:31 -0400
Date: Fri, 11 May 2007 11:46:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, bunk@stusta.de,
       randy.dunlap@oracle.com, akpm@linux-foundation.org,
       rpjday@mindspring.com, marcel@holtmann.org, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
Message-ID: <20070511114605.4c2698ec@the-village.bc.nu>
In-Reply-To: <4643BDF2.9030105@gmail.com>
References: <4643BDF2.9030105@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The email address is the problem I was trying to fix; with multiple current 
> and non-current authors and maintainers who might not even be authors the 
> address(es) available from the tag confuse the issue of whom to contact. 
> It's moreover also information that easily outdated.
> 
> A bit more than half of the tags in the tree don't include an email address 
> already and I'll submit patches removing more...

Please don't do this

NACK this change.

Whether someone puts their email address into the entry is their own
business. We do not need a style police for module author entries.

At most you might want to put

	"If you include an email address then please use an address that
	 you expect to keep for the long term, and if you change address
	 please remember to update or remove the entry"

> A bit more than half of the tags in the tree don't include an email 
> address already and I'll submit patches removing more...

And I'll NAK every one which hasn't been signed off by the email address
listed OR the address bounces. In which case removing it is good.

Alan
