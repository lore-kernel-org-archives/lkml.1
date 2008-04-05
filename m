Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbYDEFWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbYDEFWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 01:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYDEFWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 01:22:12 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:49344 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYDEFWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 01:22:11 -0400
X-IronPort-AV: E=Sophos;i="4.25,608,1199682000"; 
   d="scan'208";a="51396592"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: PATCH [1/1]: Don't return symbol lables in init sections after they have been freed
Date: Sat, 5 Apr 2008 01:13:43 -0400
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <200803041847.15884.rgetz@blackfin.uclinux.org> <200804021801.25937.rgetz@blackfin.uclinux.org> <200804040941.42275.rusty@rustcorp.com.au>
In-Reply-To: <200804040941.42275.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804050113.43433.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 05 Apr 2008 05:13:31.0441 (UTC) FILETIME=[CA331A10:01C896DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 3 Apr 2008 19:41, Rusty Russell pondered:
> On Thursday 03 April 2008 08:01:25 Robin Getz wrote:
> > On Tue 4 Mar 2008 20:43, Rusty Russell pondered:
> > >     As to the actual patch, your kallsyms.c patch matches
> > > a2da4052f1df6bc77749f84496fe731ab8b458f7's change to extable.c: please
> > > resubmit with just that one.  For bonus points, look at combining the
> > > extable and kallsyms logic so we don't diverge in future...
> >
> > OK since this took so long, I went for bonus points...
> 
> Looks good.  I don't have extratext in my kernel tho 
> (v2.6.25-rc8-139-ge315c12). 

OK - for some reason - I tested the patch, sent it upstream, but it wasn't 
kept in our local version when we updated to 2.6.24 :(

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a3b81113fb6658629f4ebaabf8dd3067cd341020

I'll update and send something new.

> Otherwise I'd suspect it should be consistently used between extable 
> and kallsyms. 


