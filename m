Return-Path: <linux-kernel-owner+w=401wt.eu-S1760499AbYB1PJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760499AbYB1PJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbYB1PJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:09:03 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:60673 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbYB1PJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:09:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hXEHklrPCFdiq2gKfwdRCdyZLDV/dj/r9M8sI7uXfs4X7WrafBHa/edrLEDjsMY09YQb7Eez5ZKnsaD9obZ1Sgj6WM8AI/uXGN0uzpnw1BpBYF+Q2fhowaYL4vZzHM/3hr/mBRFsf8fgYk7BiOqasdBbrMdFFiaQjMZFvAc1Of8=
Message-ID: <cfd18e0f0802280708r26fc88ch5a488eb8bc1227c5@mail.gmail.com>
Date: Thu, 28 Feb 2008 16:08:56 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: epoll and shared fd's
Cc: 7eggert@gmx.de, "Davide Libenzi" <davidel@xmailserver.org>,
       "Pierre Habouzit" <madcoder@debian.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Marc Lehmann" <schmorp@schmorp.de>,
       "David Schwartz" <davids@webmaster.com>
In-Reply-To: <19752.1204206788@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9MZLT-1YO-33@gated-at.bofh.it> <9N6Ng-5tn-21@gated-at.bofh.it>
	 <9P5WE-33i-11@gated-at.bofh.it> <9Pk9l-1KA-1@gated-at.bofh.it>
	 <9PNNZ-b0-5@gated-at.bofh.it> <a19Lb-1F0-13@gated-at.bofh.it>
	 <a19Lb-1F0-11@gated-at.bofh.it>
	 <E1JU4Lu-0000mn-H2@be1.7eggert.dyndns.org>
	 <19752.1204206788@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 2:53 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Tue, 26 Feb 2008 19:16:30 +0100, Bodo Eggert said:
>  > Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
>
>
> > >               file  handle  have  been  closed.  This means that
>  > >               even after a file descriptor that is  part  of  an
>  > >               epoll  set has been closed, events may be reported
>  > >               for that file descriptor if other file descriptors
>  > >               referring  to the same underlying file description
>  > >               remain open.
>
>  Is it worth making special mention of the case where a process gets events
>  for a FD that it has closed, because a parent or child process still has
>  an inherited copy of the FD still open?

I'm not sure -- perhaps under a BUGS section?  Did you read my reply
about this point in the thread "Re: epoll design problems with common
fork/exec patterns"?

Cheers,

Michael


-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
