Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbXF1Wu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbXF1Wu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbXF1WuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:50:21 -0400
Received: from mail.tmr.com ([64.65.253.246]:44904 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759911AbXF1WuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:50:20 -0400
Message-ID: <46843B9B.2080700@tmr.com>
Date: Thu, 28 Jun 2007 18:52:11 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Michael Kerrisk <mtk-manpages@gmx.net>
CC: "Alexander E. Patrakov" <patrakov@ums.usu.ru>,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: man-pages-2.59 and man-pages-2.60 are released
References: <467F8FCF.4080009@gmx.net> <4683BC76.8070805@ums.usu.ru> <20070628161720.298550@gmx.net>
In-Reply-To: <20070628161720.298550@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
> Alexander,
> 
>>> I just released man-pages-2.59 and man-pages-2.60.
>>>
>>> These releases are now available for download at:
>>>
>>>     http://www.kernel.org/pub/linux/docs/manpages
> 
> Yes, just this morning I decided to tidy away some of the old
> tarballs into a newly created "old" directory.
>  
>> There is one little problem with this: there is no stable URL for a given 
>> version. 
> 
> Well, there never really was.  To date, most old tarballs have
> had only a limited life on kernel.org.
> 
Why? I'm not questioning the policy, it's just that if HUGE kernel 
versions are kept available forever, a tiny man page tar would not seem 
to be a disk space issue.

>> This hurts, e.g., automated Linux From Scratch rebuilds (the 
>> official script grabs the URL from the book, but it becomes invalid too
>> soon).
>>
>> Could you please, in order to avoid this, do what SAMBA team does: place 
>> into http://www.kernel.org/pub/linux/docs/manpages/Old not only old 
>> versions, but also the current version? This way, LFS will be sure that
>> the  2.60 version is always available as 
> 
> As noted above old versions never were "always available" on
> kernel.org...
> 
>> http://www.kernel.org/pub/linux/docs/manpages/Old/man-pages-2.60.tar.bz2 
>> (even if it is in fact the latest version).
> 
> How about a link in /pub/linux/docs/manpages/ of the form 
> "LATEST-IS-m.xy"?  Rob Landley was wanting something like this,
> and I guess it would be easy for LFS to build a simple
> script that looks for that link and deduces "man-pages-m.xy" 
> from it.  (I've just now created such a link in the directory,
> as an example.)
> 
Why not just a link with a fixed name (LATEST?) which could be updated? 
I assume installing a new version is automated to create and install the 
tar, any needed links, the push to mirrors, etc. So it would just be a 
single step added to an automated procedure. You could have a link in 
"Old" as requested, and any other links as well.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
