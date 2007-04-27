Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbXD0Ajm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbXD0Ajm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXD0Ajm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:39:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:56033 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbXD0Aja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:39:30 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mel Gorman <mel@skynet.ie>
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 VDSO compile error II
Date: Fri, 27 Apr 2007 02:39:13 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <200704261724.46027.ak@suse.de> <20070426154518.GG16909@skynet.ie>
In-Reply-To: <20070426154518.GG16909@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704270239.13895.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> That's vdso.lds.S, not vdso.lds. The VDSO_TEXT_OFFSET is still 0x400.
> This is what I should have posted the last time
> 
> --- build/arch/x86_64/vdso/voffset.h.orig	2007-04-26 08:43:31.523739878 -0700
> +++ build/arch/x86_64/vdso/voffset.h	2007-04-26 08:43:38.839579356 -0700
> @@ -1 +1 @@
> -#define VDSO_TEXT_OFFSET 0x500
> +#define VDSO_TEXT_OFFSET 0x400

It's definitely 0x400 here. Is your patch reversed and you want 0x500? 

-Andi
