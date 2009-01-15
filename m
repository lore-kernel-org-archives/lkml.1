Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbZAOGz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbZAOGz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbZAOGzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:55:20 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:42051 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755856AbZAOGzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:55:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lhjruuMYb9pmYSNj6a9M9guXQofeOIx0EBpDeWxKMEffApYwS3VWKfSb5a2QPqKI3xkMtfE9Xv6MlmF1Ig5dyFHtPuc0jSrk9Z/IfcRKmyGTKYbi3QQMn/XkLb4JwKVSIojdBPxLyUrzqkZpdTa6VpwRBKHf6QHn4+gh5sei/mE=  ;
X-YMail-OSG: b4bOpNwVM1mgTLyXwHUShQu1hkD0YzkdV63oB4KjIYFzi5zzgV00bX6F4zRhkGIieQRewN3qv0VeofkPcRtqKovHVjLfpONLoYGsevDHgH_5Q7huT0eb7wf1RLS9VZQzzulLSh2rjqZn733oXFGX8lIVbM7YhbKSwMz60DZ7cwRTDfOQIYHxk8V2y.BX7WpCxIstdWyrYoLTkw8R86v8vHWEsCg-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
Date: Thu, 15 Jan 2009 17:54:57 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20090113122455.GA24824@dhcp35.suse.cz> <20090113123425.GB29926@elte.hu>
In-Reply-To: <20090113123425.GB29926@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151754.58311.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009 23:34:25 Ingo Molnar wrote:
> * Michal Hocko <mhocko@suse.cz> wrote:
> > Hi,
> > I am not sure whether someone has already reported this, but
> > I can see the following early boot WARNING with the 2.6.29-rc1 kernel in
> > the serial console output:
> >
> > ------------[ cut here ]------------
> > WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
>
> That one should be fixed in tip/master and it is in the to-Linus queue of
> fixes:
>
>   http://people.redhat.com/mingo/tip.git/README
> 	
> it's this commit:
>
>   01e3eb8: Revert "sched: improve preempt debugging"
>
> if you want to cherry-pick the fix.

OK, but I still don't think this is the actual problem, but there is
something amiss in the init code being exposed by it.

