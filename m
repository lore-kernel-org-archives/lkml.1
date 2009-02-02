Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbZBBSWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbZBBSWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbZBBSUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:20:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791AbZBBSUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:20:47 -0500
Date: Mon, 2 Feb 2009 10:17:32 -0800
From: Greg KH <gregkh@suse.de>
To: Jesper Krogh <jesper@krogh.cc>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.13
Message-ID: <20090202181732.GB6903@suse.de>
References: <20090125004823.GA6711@kroah.com> <4985A1C9.4050005@krogh.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4985A1C9.4050005@krogh.cc>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 01, 2009 at 02:21:13PM +0100, Jesper Krogh wrote:
> Greg KH wrote:
>> We (the -stable team) are announcing the release of the 2.6.27.13
>> kernel.
>> It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
>> series are strongly encouraged to upgrade.
>> I'll also be replying to this message with a copy of the patch between
>> 2.6.27.12 and 2.6.27.13
>> The updated 2.6.27.y git tree can be found at:
>>         
>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
>> and can be browsed at the normal kernel.org git web browser:
>>         
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary
>
> This may be just noise, but recently I have begun seeing Zombie processes 
> hanging on some nodes in the computescluster:
>
> 2006      2055  0.0  0.0   9144  1260 ?        Ss   07:24   0:00      \_ 
> -bash /z/gridengine/default/spool/node30/job_scripts/692747
> 2006      2060 39.0 38.7 1696468 1573884 ?     S    07:24 160:21   \_ 
> /usr/bin/perl /z/home/trunk//bin/workqueue/worker
> 2006      2225  0.0  0.0      0     0 ?        Z    07:29   0:00       \_ 
> [sh] <defunct>
>
> ps faux output.
>
> Killing the parent process makes it go awasy, but this one has been sitting 
> there for almost 7 hours by now, without going away, essentially hagning 
> this process.

Does this also happen on older .27-stable releases?  Or is it something
new to .13?

thanks,

greg k-h
