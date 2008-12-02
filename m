Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYLBTpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYLBTpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYLBTpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:45:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:27139 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbYLBTpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:45:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=nqjJSgazKIlA78WzjJn+5tuCS1okFnNBKMVKNYiis9icNm9UKpCp5U6YTcuCjLm5NR
         a20Glx5AGCSTiIWjEeF3Uc0kHWhDMvFcbEjBhmCGBwENwzeQ0m1zJUfYdEzb8ImQG/Si
         2ReD28aoiTWJwnzYy5Jc8U7IerG/hyOdicwVA=
Date: Tue, 2 Dec 2008 20:45:03 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       "Michael B. Trausch" <mike@trausch.us>
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202204503.57363502@varda>
In-Reply-To: <alpine.LFD.2.00.0812021120110.3256@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org>
	<20081202131442.42e7df48@varda>
	<alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org>
	<20081202165637.09984819@varda>
	<alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
	<20081202194907.4eaffc0a@varda>
	<alpine.LFD.2.00.0812021120110.3256@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 2 Dec 2008 11:23:42 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> escribió:

> 
> 
> On Tue, 2 Dec 2008, Alejandro Riveira Fernández wrote:
> > 
> >  Here you go 
> > 
> >  [alex@varda:kernel/linux-2.6]$ git bisect bad                                   
> > 31168481c32c8a485e1003af9433124dede57f8d is first bad commit
> 
> Excellent. One last step - can you verify that just reverting this commit 
> makes your problems go away?
> 
> IOW, just do
> 
> 	git bisect reset
> 
> to get out of bisect mode, and then do
> 
> 	git revert 31168481c32c8a485e1003af9433124dede57f8d

 Well i already sent the result of the revert on another mail;
it did not help :(

 I tried again with what i thought was my "good" commit and the
bug is there too :/

 could it be that something changed in userspace[1] between the
day i installed the 2.6.28-rc6-00007-ged31348 and today that
make this bug trigger? i dunno

 Next step is try to find an "actually good" kernel and bisect
again sigh... 2.6.27.6 seems to work ok



> 
> and check that the end result is all good?
> 
> That's just to double-check that the revert is sufficient, but also 
> because "git bisect" is very sensitive to false information (ie if it 
> happens that a bug sometimes is not entirely repeatable, then a single 
> wrong "git bisect bad/good" will result in the pinpointed commit being 
> possibly totally the wrong one).
> 
> And Al - can you double-check that commit?
> 
> 		Linus

 [1] distro updates

