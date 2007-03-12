Return-Path: <linux-kernel-owner+w=401wt.eu-S965839AbXCLNOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965839AbXCLNOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965840AbXCLNOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:14:41 -0400
Received: from station18k.dscga.com ([192.24.222.18]:35064 "EHLO
	suzuka.mcnaught.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965839AbXCLNOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:14:41 -0400
X-Greylist: delayed 1382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 09:14:41 EDT
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       amanda-hackers@amanda.org, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org
Subject: Re: RSDL for 2.6.21-rc3- 0.29
References: <20070311013506.GD10459@waste.org>
	<200703121648.22734.kernel@kolivas.org>
	<200703120237.39477.gene.heskett@gmail.com>
	<200703120604.42776.gene.heskett@gmail.com>
From: Douglas McNaught <doug@mcnaught.org>
Date: Mon, 12 Mar 2007 08:51:37 -0400
In-Reply-To: <200703120604.42776.gene.heskett@gmail.com> (Gene Heskett's
 message of "Mon, 12 Mar 2007 06:04:42 -0400")
Message-ID: <873b4alj52.fsf@suzuka.mcnaught.org>
User-Agent: Gnus/5.1006 (Gnus v5.10.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett <gene.heskett@gmail.com> writes:

> If, and I have previously, I revert to a 2.6.20-ck1 patching, this does 
> not occur.  So my contention is that someplace in this recent progression 
> from 2.6.20 to 2.6.21-rc3, there is a patch which acts to change how 
> c-time is being reported to tar.  Or there is a spillage into c-times 
> when tar does its estimate scans where the output goes to /dev/null.
> Or possibly even this version of tar is doing it differently.  I just 
> looked up how to get the c-times out of ls, and they, as far as ls is 
> concerned, look sane.  But tars actions while running a 2.6.21-rcX kernel 
> certainly are not.  I do have a plain -rc2 I can try, so that will be the 
> next test.  If that also fails in this manner, I'll build a later 
> 2.6.20-2 or whatever to verify that it doesn't so suffer.

You may find 'strace' useful to track down this sort of thing (though
the output can be voluminous).

-Doug
