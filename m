Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0BHJfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:35:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54785 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0BHJfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:35:43 -0500
Message-ID: <4B6FD9A2.8070008@zytor.com>
Date: Mon, 08 Feb 2010 01:30:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: rostedt@goodmis.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Tromey <tromey@redhat.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       utrace-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       JimKeniston <jkenisto@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: linux-next: add utrace tree
References: <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain> <m3636oh2rt.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain> <1264575134.4283.1983.camel@laptop> <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain> <1264600792.31321.464.camel@gandalf.stny.rr.com> <4B607B1A.3080007@zytor.com> <20100208065425.GB1290@ucw.cz>
In-Reply-To: <20100208065425.GB1290@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2010 10:54 PM, Pavel Machek wrote:
>>
>> No, it has nothing to do with ring.  It has to do with modifying code
>> that another CPU could be executing at the same time, and with modifying
>> code on the same processor through another virtual alias (they are
>> different issues.)  The same issues apply regardless of the CPL of the
>> processor.
>
> ...but these are always 'there could be cpu bugs around' issues,
> right? Like amd k6. AFAICT x86 always supported self-modifying code
> without any extra barriers needed...
>

*Self*-modifying code, yes.  *Cross*-modifying code, no.

	-hpa
