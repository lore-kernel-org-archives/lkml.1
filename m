Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbXBEHMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbXBEHMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 02:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXBEHMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 02:12:09 -0500
Received: from postman.lauml.com ([205.134.240.66]:35753 "EHLO
	postman.lauml.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbXBEHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 02:12:08 -0500
X-Greylist: delayed 1503 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 02:12:08 EST
Message-ID: <45C6D2C1.5010103@xman.org>
Date: Sun, 04 Feb 2007 22:46:25 -0800
From: Christopher Smith <x@xman.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061221)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: bert hubert <bert.hubert@netherlabs.nl>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: regarding generic AIO, async syscalls precedent + some benchmarks
 by lighttpd
References: <20070204225541.GA18359@outpost.ds9a.nl> <Pine.LNX.4.64.0702041548480.18633@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0702041548480.18633@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> Yes, that is some very interesting data IMO. I did not bench the GUASI 
> (userspace async thread library) against AIO, but those numbers show that a 
> *userspace* async syscall wrapper interface performs in the ballpark of AIO.
> This leads to some hope about the ability to effectively deploy the kernel 
> generic async AIO (being it fibril or kthreads based) as low-impact async 
> provider for basically anything.
>   

SGI's kaio patch to linux kind of went that route (using kthreads) for 
non-SCSI async IO. It wasn't a bad way to go, but at least for 
disk-based access they achieved much better results when they could go 
right to the hardware.

--Chris
