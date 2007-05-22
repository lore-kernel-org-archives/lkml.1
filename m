Return-Path: <linux-kernel-owner+w=401wt.eu-S1761914AbXEVNxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761914AbXEVNxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 09:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbXEVNxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 09:53:08 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:47996 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbXEVNxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 09:53:07 -0400
Date: Tue, 22 May 2007 09:53:03 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
Message-ID: <alpine.DEB.0.99.0705220950160.3308@sigma.j-a-k-j.com>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   given that:
> 
> $ grep -r "define.*NORET_TYPE" *
> include/linux/ext4_fs.h:# define NORET_TYPE    /**/
> include/linux/linkage.h:#define NORET_TYPE    /**/
> include/linux/ext3_fs.h:# define NORET_TYPE    /**/
> $
> 
> is there any obvious value to the 30 or so uses of that macro
> sprinkled throughout the tree?

Since it evaluates to absolutely empty code during pre-processing, there 
is no obvious value. The question is whether there is some odd hackish 
non-obvious value, I'd expect. (I'd also expect that to be another "no".)

If something that evaluates to nothingness ("There was nothing left...not 
even a hole!") actually does anything, then somebody in the 
standards-compilers-users pipeline needs to be violently beaten for 
stupidity.
