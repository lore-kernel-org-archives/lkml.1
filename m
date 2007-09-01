Return-Path: <linux-kernel-owner+w=401wt.eu-S933198AbXIAWOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbXIAWOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932208AbXIAWOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:14:40 -0400
Received: from mail.suse.de ([195.135.220.2]:45459 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192AbXIAWOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:14:39 -0400
To: David Miller <davem@davemloft.net>
Cc: byron.bbradley@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: XFS Fails Quality Assurance Tests on ARM
References: <fb80ve$i5q$1@sea.gmane.org>
	<20070830.213901.48806818.davem@davemloft.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Sep 2007 00:14:38 +0200
In-Reply-To: <20070830.213901.48806818.davem@davemloft.net>
Message-ID: <p73ps12vxrl.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Byron Bradley <byron.bbradley@gmail.com>
> Date: Fri, 31 Aug 2007 03:12:46 +0000 (UTC)
> 
> > Anybody got any ideas of how we fix this?
> 
> I don't know how much testing XFS gets on ARM, but one thing that some
> ARM chips have is D-cache aliasing problems and one thing XFS uses a
> lot is virtual remapping of various data structures via vmap().
> 
> This might be what is causing the problems.

AFAIK XFS uses vmap() mainly during log replay. If David's theory
was true then the failures must be seen during tests that do 
this.

-Andi
