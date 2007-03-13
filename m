Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbXCMDBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbXCMDBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 23:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbXCMDBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 23:01:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:31508 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbXCMDBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 23:01:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bUx1eiFmie140lHawXgg1hM0IeF7uyH+J7vjzl4hsyk+ykAeZrV/V3DA8CXr5jCfbHgE+T9flvg+F56bIap/ERuwcV+e+TB/4EHvWdj0yDpUoCAREpgwVeONsFDO0BkhqURJfj3CZwdNxcnbXvVeMhO5LVJyzBYZMAdRLgsk7AU=
Message-ID: <29495f1d0703122001x67158365s53dea258acb1aa24@mail.gmail.com>
Date: Mon, 12 Mar 2007 20:01:16 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: Stracing Amanda (was: RSDL for 2.6.21-rc3- 0.29)
Cc: linux-kernel@vger.kernel.org, "Douglas McNaught" <doug@mcnaught.org>,
       "Patrick Mau" <mau@oscar.ping.de>
In-Reply-To: <200703122239.29256.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070311013506.GD10459@waste.org>
	 <20070312195436.GA15319@oscar.prima.de>
	 <874poqj5db.fsf_-_@suzuka.mcnaught.org>
	 <200703122239.29256.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> On Monday 12 March 2007, Douglas McNaught wrote:
> >Patrick Mau <mau@oscar.ping.de> writes:
> >> Why not temporarly replace "/bin/tar" with a shell script that does:
> >>
> >> #!/bin/sh
> >> exec strace -f -o output /bin/real.tar $@
> >
> >You beat me to it.  :) I've done that before; it's a great suggestion.
> >
> >Except that if you expect 'tar' to be invoked multiple times in a run,
> >you should probably use 'output.$$' for the output filename so things
> >don't get clobbered.
> >
> >-Doug
>
> In my case, Doug, it will get invoked 64 times, amanda does a dummy run to
> get an estimate, calculates what to do based on that output which is 32
> runs, 1 per disklist entry and I have 32, and then reruns tar with the
> appropriate level options against each individual disklist entry.
>
> But I'm puzzled a bit, what does the double $$ do?, or it buried someplace
> in the bash manpage?  Its not something I've stumbled over yet.

buried indeed:

"Special Parameters:
  ...
       $      Expands to the process ID of the shell.  In a  ()  subshell,  it
              expands  to  the  process  ID of the current shell, not the sub‐
              shell.
"

Thanks,
Nish
