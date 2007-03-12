Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbXCLTWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbXCLTWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXCLTVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:21:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:28233 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbXCLTVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:21:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f/5DG865z6jMWf0z5lly2uYdKZp/bR3+pQY91PZAqOyXvcPraukSs9kwzVT+ARRVv8ArLd1xtdgvNSdq2wdMp0h2cc4p7o2UtVrq2Jpmdv7r5Mm+NU2gBDEli4Ez8kL33x+UxmKiQsvsVSpsNJYDi3ENDnN1kjkzV+4bpb7msAM=
Message-ID: <75b66ecd0703121214r7a8d91cfh12c9ee9243188e03@mail.gmail.com>
Date: Mon, 12 Mar 2007 15:14:30 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: RSDL for 2.6.21-rc3- 0.29
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200703121510.18268.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070311013506.GD10459@waste.org>
	 <200703121428.29947.gene.heskett@gmail.com>
	 <87wt1mjo4q.fsf@suzuka.mcnaught.org>
	 <200703121510.18268.gene.heskett@gmail.com>
X-Google-Sender-Auth: a59cb74b35691b7e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> On Monday 12 March 2007, Douglas McNaught wrote:
> >Gene Heskett <gene.heskett@gmail.com> writes:
> >> I'd considered it, but with 32 dle entries, the whole strace output
> >> would be terrabytes & I don't have THAT much disk.  Not to mention it
> >> traces only the parent process, so tar would be merrily marching along
> >> to its own drummer and not traced I'm  afraid.
> >
> >$ strace -ff
> >
> >-Doug
>
> Someone else suggested the single -f, and I tried that, but even with the
> shell history set for 100,000 lines, i can't get back to the start, and I
> think its mucking with the shell arguments numbering as what I can see is
> about 5 reads through /etc/services accompanied by endless complaints
> of -EBADFD, the the logfile it generates says the port it was given was
> rejected when amcheck was run, here is that snip:

Can we start a new thread for this amanda issue?  It does not seem to
have anything to do with Con's scheduler...

Lee
