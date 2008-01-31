Return-Path: <linux-kernel-owner+w=401wt.eu-S932531AbYAaI6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbYAaI6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYAaI5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:57:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:20661 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYAaI5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:57:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ARX6Uo4V2h1PDQUwJlWepRJpk7dUfagF9nQUcAvjYnYG4oOTzpnqXp798qEnoqFuCD/buDY8TPcHsDG7r9bjIiQdXWu5vp9IdFD96Q4MGl8qQ8q8gbpGyJLTFTUv5q1GRmikrzd3COiwlNQZ//EOoD3alsZd2iJd2FTsUT9l6Xw=
Message-ID: <38b2ab8a0801310057y1e003c27tae24d6ffd2aadf0b@mail.gmail.com>
Date: Thu, 31 Jan 2008 09:57:48 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Francis Moreau" <francis.moro@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Kbuild] How to clean a particular directory ?
In-Reply-To: <20080131085408.GA14470@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801310038o2906ab68ta8893240576d806d@mail.gmail.com>
	 <20080131084851.GB14160@linux-sh.org>
	 <20080131085408.GA14470@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 9:54 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> Makefile says:
>
> # Use make M=dir to specify directory of external module to build
> # Old syntax make ... SUBDIRS=$PWD is still supported
> # Setting the environment variable KBUILD_EXTMOD take precedence
> ifdef SUBDIRS
>   KBUILD_EXTMOD ?= $(SUBDIRS)
> endif
> ifdef M
>   ifeq ("$(origin M)", "command line")
>     KBUILD_EXTMOD := $(M)
>   endif
> endif
>
> so M= is apparently the newfangled (and undocumented) way of doing this.
>

Good catch.

I tried "make help" to search for revelant info but didn't find anything useful.

Thanks
-- 
Francis
