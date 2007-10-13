Return-Path: <linux-kernel-owner+w=401wt.eu-S1763170AbXJMS4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763170AbXJMS4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbXJMS4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:56:22 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40999 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbXJMS4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:56:21 -0400
Date: Sat, 13 Oct 2007 14:55:44 -0400
Message-Id: <200710131855.l9DItiv7007377@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, apw@shadowen.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 checkpatch updates, new checkfiles script 
In-reply-to: Your message of "Sat, 06 Oct 2007 13:13:43 +0200."
             <20071006111343.GA29484@elte.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071006111343.GA29484@elte.hu>, Ingo Molnar writes:
> 
> * Erez Zadok <ezk@cs.sunysb.edu> wrote:
> 
> > So, I ran the above script and it found nearly 1.5 million reported 
> > warnings/errors, with drivers being the largest abuser, not 
> > surprisingly. [...]
> 
> have you tried that with the latest version too:
> 
>   http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-next
> 
> it outputs far fewer false positives.
> 
> 	Ingo

OK, I just checked the latest version of checkpatch on 2.6.23.1.  Here are
the stats broken down by subsystem and category of message (error, warning,
or subjective check):

      SUBSYSTEM   Error    Warn   Check   Total
        drivers  866113  168093    7712 1041918
             fs  102133   14016    1236  117385
           arch   78531   32898    5400  116829
        include   41237   42974    1838   86049
          sound   59175   20319    1184   80678
            net    6898    6614     659   14171
         crypto    4333     467      32    4832
            lib    4193     383      61    4637
         kernel     950     895     162    2007
        scripts    1205     742      26    1973
       security     501     591      39    1131
             mm     473     281      79     833
            ipc     344     119      30     493
  Documentation     191      95       6     292
          block     100     146      28     274
           init      64      69      28     161
            usr      14      19       0      33
          TOTAL 1166455  288721   18520 1473696

Erez.
