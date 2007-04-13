Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbXDMIQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbXDMIQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXDMIQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:16:55 -0400
Received: from mx1.suse.de ([195.135.220.2]:39242 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbXDMIQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:16:53 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [AppArmor 37/41] AppArmor: Main Part
Date: Fri, 13 Apr 2007 10:17:05 +0200
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
Message-Id: <200704131017.05557.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 12:37, Alan Cox wrote:
> The proc file system may not be mounted at /proc. There are environments
> where this is done for good reason (eg not wanting the /proc info exposed
> to a low trust environment). Another is when FUSE is providing an
> arbitrated proc either by merging across clusters or by removing stuff.
> [...]
> Why can't this be done in the profile itself to avoid kernel special case
> uglies and inflexibility ?

Good points. I'm in fact not sure how this could have been missed, and indeed 
it makes more sense to put this in profiles.

Thanks,
Andreas
