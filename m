Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbXCLS2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbXCLS2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXCLS2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:28:49 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:49174 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXCLS2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:28:48 -0400
Date: Mon, 12 Mar 2007 14:28:29 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: RSDL for 2.6.21-rc3- 0.29
In-reply-to: <873b4alj52.fsf@suzuka.mcnaught.org>
To: linux-kernel@vger.kernel.org
Cc: Douglas McNaught <doug@mcnaught.org>, Con Kolivas <kernel@kolivas.org>,
       amanda-hackers@amanda.org, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org
Message-id: <200703121428.29947.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070311013506.GD10459@waste.org>
 <200703120604.42776.gene.heskett@gmail.com>
 <873b4alj52.fsf@suzuka.mcnaught.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007, Douglas McNaught wrote:
>Gene Heskett <gene.heskett@gmail.com> writes:
>> If, and I have previously, I revert to a 2.6.20-ck1 patching, this
>> does not occur.  So my contention is that someplace in this recent
>> progression from 2.6.20 to 2.6.21-rc3, there is a patch which acts to
>> change how c-time is being reported to tar.  Or there is a spillage
>> into c-times when tar does its estimate scans where the output goes to
>> /dev/null. Or possibly even this version of tar is doing it
>> differently.  I just looked up how to get the c-times out of ls, and
>> they, as far as ls is concerned, look sane.  But tars actions while
>> running a 2.6.21-rcX kernel certainly are not.  I do have a plain -rc2
>> I can try, so that will be the next test.  If that also fails in this
>> manner, I'll build a later 2.6.20-2 or whatever to verify that it
>> doesn't so suffer.
>
>You may find 'strace' useful to track down this sort of thing (though
>the output can be voluminous).
>
>-Doug

I'd considered it, but with 32 dle entries, the whole strace output would 
be terrabytes & I don't have THAT much disk.  Not to mention it traces 
only the parent process, so tar would be merrily marching along to its 
own drummer and not traced I'm  afraid.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I'm definitely not in Omaha!
