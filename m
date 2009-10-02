Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZJBPcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZJBPcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbZJBPcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:32:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbZJBPcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:32:16 -0400
Date: Fri, 2 Oct 2009 11:31:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091002153117.GB4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com> <20091002124921.GA4494@redhat.com> <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:27:55PM +0200, Corrado Zoccolo wrote:
> On Fri, Oct 2, 2009 at 2:49 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Oct 02, 2009 at 12:55:25PM +0200, Corrado Zoccolo wrote:
> >
> > Actually I am not touching this code. Looking at the V10, I have not
> > changed anything here in idling code.
> 
> I based my analisys on the original patch:
> http://lkml.indiana.edu/hypermail/linux/kernel/0907.1/01793.html
> 

Oh.., you are talking about fairness for seeky process patch. I thought
you are talking about current IO controller patches. Actually they both
have this notion of "fairness=1" parameter but do different things in 
patches, hence the confusion. 

Thanks
Vivek


> Mike, can you confirm which version of the fairness patch did you use
> in your tests?
> 
> Corrado
> 
> > Thanks
> > Vivek
> >
