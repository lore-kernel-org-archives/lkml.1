Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0BXQwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 11:52:34 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46502 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab0BXQwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 11:52:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H/mIUeq+9aaVNybse5qn+jCXG9tQUiPzWEDFJbRJG4Ynxsxtm0yCYdTfNU9gjt5cj+
         DW2mg8raU/LQ0pmeeMOhH+dxT36XYnkoam7MOYc63Gi8lQ2c8pPJ8YZS1DJ61uNJsLio
         8o5E67CxmiFIvRg6XSvQYlLTYSo4aWUaZ9wrw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002241609050.4245@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>
	 <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>
	 <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
	 <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
	 <520f0cf11002220311l2a0caa83lf3ae2817b78501b6@mail.gmail.com>
	 <49b7c2351002231708r279049f9hcc9cc6ff205a47fb@mail.gmail.com>
	 <25891f3e1002231719u4d38ed52w99c66ac669c3d965@mail.gmail.com>
	 <49b7c2351002240643s1aebe384wee5ee7951e62640e@mail.gmail.com>
	 <alpine.LFD.2.00.1002241609050.4245@localhost.localdomain>
Date: Thu, 25 Feb 2010 01:52:31 +0900
Message-ID: <49b7c2351002240852u3b2e7a56g1b0140d37a02c81f@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt1
From: GeunSik Lim <leemgs1@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dhaval Giani <dhaval.lists@thegianis.in>, John Kacur <jkacur@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 12:09 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> So, I tried linux-2.6.33-rc8-rt1 based on tip/rt/head as you explained.
>>
>> Git development branch:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head
> What's the sha1 of the head commit ?
> Thanks,
>        tglx
>
Dear Thoomas,

Below was the  recent commit number  when I typed "git clone" command.

commit ed0799048b4a38ffb6e33755ba5e6b5dfa9a24d2
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sun Feb 21 23:14:28 2010 +0100

    v2.6.33-rt1

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit b635a77f9aadc5ed3fc5a949e3f219c24cdd254c
Author: Carsten Emde <C.Emde@osadl.org>
Date:   Sat Jan 16 17:14:04 2010 +0100

    hwlat_detector-avoid-smp_processor_id.patch

    Avoid smp_processor_id() in preemptible code.

    Signed-off-by: Carsten Emde <C.Emde@osadl.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
             . . . . . . below omission . . . . . .


and, version info is 2.6.33-rc8-rt1 as belows.

[invain@localhost head]$ head Makefile
VERSION = 2
PATCHLEVEL = 6
SUBLEVEL = 33
EXTRAVERSION = -rc8-rt1
NAME = Man-Eating Seals of Antiquity

# *DOCUMENTATION*
# To see a list of typical targets execute "make help"
# More info can be located in ./README
# Comments in this file are targeted only to the developer, do not


Thanks,
Geunsik Lim.

-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
