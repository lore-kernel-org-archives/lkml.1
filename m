Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbXKMHT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbXKMHT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXKMHTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:19:17 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:4809 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbXKMHTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:19:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kAagJluJXQb2pX3Bi8zQ6Dr05NCyF/7722uO+x4KsexolZv9xqSyjKXYE3TVjaXFqkMe036upSqFDjSuOGS6E97vptNdqYO1wfVAl2qGEc7IN+bXt90iXdoe3ZEKtGDQ8yeArKMpuERE46PSNYueg8GK9b4vHPk1amwCWCqBHyY=
Message-ID: <661de9470711122319m1b8704d1y2f06b1199a21dd52@mail.gmail.com>
Date: Tue, 13 Nov 2007 12:49:16 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: top lies ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200711131008.56627.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711131008.56627.a1426z@gawab.com>
X-Google-Sender-Auth: 52af3aa42976b6d2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 13, 2007 12:38 PM, Al Boldi <a1426z@gawab.com> wrote:
> kloczek wrote:
> > Some data showed by top command looks like completly trashed.
> > Fragment from top output:
> >
> > Mem:   2075784k total,  2053352k used,    22432k free,    19260k buffers
> > Swap:  2096472k total,      136k used,  2096336k free,  1335080k cached
> >
> >    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  SWAP nFLT
> > WCHAN     COMMAND 14515 mysql     20   0 1837m 563m 4132 S   39 27.8
> > 27:14.20 1.2g   18 -         mysqld
> >
> > How it is possible that swap ussage is 136k and swapped out portion of (in
> > this case) mysqld process is 1.2g ?
>
> Welcome to OverCommit, aka OOM-nirvana.
>
> Try this:
> # echo 2 > /proc/sys/vm/overcommit_memory
> # echo 0 > /proc/sys/vm/overcommit_ratio
>
> But make sure you have enough swap.
>
>
> Thanks!

The swap cache looks pretty big, may be top is including that data
while reporting swap usage.

Balbir
