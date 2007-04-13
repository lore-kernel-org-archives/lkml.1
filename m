Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbXDMIsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbXDMIsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXDMIsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:48:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:58339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbXDMIsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:48:07 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [AppArmor 37/41] AppArmor: Main Part
Date: Fri, 13 Apr 2007 10:48:17 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org
References: <20070412090809.917795000@suse.de> <20070412090848.752885000@suse.de> <20070412113723.2ec7e4f0@the-village.bc.nu>
In-Reply-To: <20070412113723.2ec7e4f0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704131048.17846.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 12:37, Alan Cox wrote:
> > +		if (PTR_ERR(sa->name) == -ENOENT && (check & AA_CHECK_FD))
> > +			denied_mask = 0;
>
> Now there is an interesting question. Is PTR_ERR() safe for kernel
> pointers on all platforms or just for user ones ?

It's used for kernel pointers all over the place and mmap also mixes user 
addresses with -Exxx, so it's definitely supposed to work. I'm not sure how 
exactly the topmost page is kept from getting mapped.

Andreas
