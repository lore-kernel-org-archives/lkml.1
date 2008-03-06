Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbYCFVu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbYCFVu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYCFVuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:50:16 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:20181 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbYCFVuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:50:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s9QYtZh5ft9yZ6mG2yOlvbDAEBAszCT2EXeXoPga58GaT5BvXejIsOZCPHKLet/ZVg9XH3elLdSCMydYwbjBN8Fcbb3RIecIFeYWHFD8qtkegxKn3/l010MXA/lfPhC8K/hwrrseXrq+EvlQdaKlyO9Vafadm2NiVbceyaEuaSo=
Message-ID: <86802c440803061350g146a0b27xe358658f3315376@mail.gmail.com>
Date: Thu, 6 Mar 2008 13:50:14 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: 2.6.25-rc4: crash on boot when SMP enabled
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080306212419.GA13798@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306102927.GA4434@elf.ucw.cz> <20080306131547.GE21359@elte.hu>
	 <86802c440803061127s5ca545bch930310a0df6511fc@mail.gmail.com>
	 <20080306212419.GA13798@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 1:24 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>  > >  > On amd 8-core system, I get crash on boot... Last messages:
>  > >  >
>  > >  > Quad-Core AMD Opteron...
>  > >  > Checking TSC Synchronization [CPU#0 -> CPU#3]: passed
>  > >  > BUG: unable to handle kernel paging request at 00...005958
>  > >  > IP: __alloc_pages+0x38
>  > >  > ...
>  > >  > Call trace:
>  > >  > kmem_getpages
>  > >  > cache_grow
>  > >  > ____cache_alloc_node
>  > >  > cpuup_callback
>  > >  > kmem_cache_alloc_node
>  > >  > cpuup_callback
>  > >  > notifier_call_chain
>  > >  > _cpu_up
>  > >
>  > >  could you try latest x86.git:
>  > >
>  > >     http://people.redhat.com/mingo/x86.git/README
>  > >
>  > >  does it fix it? Could be one of the numa fixes that are queued up.
>  >
>
> > can we have your config and whole bootlog?
>
>  Config is attached.
>
>  Bootlog is a bit of problem. I can get you whole bootlog with "nosmp",
>  or maybe some jpg files of the real problem. Which one do you prefer?
>  ;-).
boot log for 2.6.24 could be good, if it can boot with that.
