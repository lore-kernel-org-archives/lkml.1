Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZESIrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZESIrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZESIrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:47:12 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:34583 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZESIrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:47:11 -0400
Date: Tue, 19 May 2009 10:47:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Abbott, MG (Michael)" <michael.abbott@diamond.ac.uk>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: cputime tree build warning
Message-ID: <20090519104700.57770120@skybase>
In-Reply-To: <4854F2500EA8C4478A508D2D92973E52046B8498@EXCHANGE25.fed.cclrc.ac.uk>
References: <20090519173251.86d755c8.sfr@canb.auug.org.au>
	<4854F2500EA8C4478A508D2D92973E52046B8498@EXCHANGE25.fed.cclrc.ac.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009 08:39:32 +0100
"Abbott, MG (Michael)" <michael.abbott@diamond.ac.uk> wrote:

> > Today's linux-next build (x86_64 allmodconfig) produced this warning:
> > 
> > fs/proc/uptime.c: In function 'uptime_proc_show':
> > fs/proc/uptime.c:14: warning: unused variable 'len'
> > 
> > Introduced by commit ed7e789abfc433e46524419b7cc51d949552505e 
> > ("[PATCH]
> > Fix idle time field in /proc/uptime") from the cputime tree.
> 
> Ouch.  I do apologise.  The (now) bogus variable len must have been
> preserved when I rebased from 2.6.29.3 to current git, and I guess I
> didn't spot the warning among all the other warnings in the build.
 
I'll fix the two problems with the patch: 1) remove len, 2) use
cputime_zero to initialize idletime and update the cputime branch.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

