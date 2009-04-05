Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbZDED25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbZDED25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 23:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbZDED2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 23:28:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:47646 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbZDED2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 23:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ElmRTQC7muwshhQp9rbH5R2bAj974VREpQUVcf9JhmatOVUkXl7DS//P/oRrOyCwUZ
         86/nFweE/h/VzRVVhz568UgFJzgP557liMBuxvDqcRSM3nCPwouWu4zIALHRPXC8fwqJ
         4k5JJ7tCG5+R8li5Nyq82OHe6WxILgphKfPOc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
	 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
Date: Sun, 5 Apr 2009 12:28:42 +0900
Message-ID: <49b7c2350904042028q8865f80tcf56500e8a009c0d@mail.gmail.com>
Subject: Re: [Announce] 2.6.29.1-rt4
From: GeunSik Lim <leemgs1@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thomas,
>
>The broken out patches are also available at the same download
>locations.
>
>Enjoy !

Thank you for new release announce.
I am using new version ( linux-2.6.29.1-rt4 ) now .
config file is http://leemgs1.googlecode.com/files/i386.2.6.29.1-rt4.ftrace.config.20090404

I have one question. What is "broken-out" 's meaning  for rt patch file?

When I opened  realtime patch  files for vanilla kernel,
I always checked 2 files like belows.
http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.1-rt4-broken-out.tar.bz2
<-- collection of seperate files for each patch.
http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.1-rt4.bz2
<-- only one patch file.

What is difference  meaning of file-name format
between "patch-2.6.29.1-rt4-broken-out.tar.bz2" and "patch-2.6.29.1-rt4.bz2" ?	
I have always wondered that.
I am sorry for sending this stupid and easy question.

Thanks,
GeunSik Lim,

2009/4/4 Thomas Gleixner <tglx@linutronix.de>:
> We are pleased to announce the next update to our new preempt-rt
> series.
>
>        - rebased to 2.6.29.1
>
>        - powerpc64 tlb rework fix by Peter
>
> Download locations:
>
>     http://rt.et.redhat.com/download/
>     http://www.kernel.org/pub/linux/kernel/projects/rt/
>
> Information on the RT patch can be found at:
>
>     http://rt.wiki.kernel.org/index.php/Main_Page
>
> to build the 2.6.29.1-rt4 tree, the following patches should be
> applied:
>
>     http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.1.tar.bz2
>     http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.1-rt4.bz2
>
> The broken out patches are also available at the same download
> locations.
>
> Enjoy !
>
>       tglx
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
