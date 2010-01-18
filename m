Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249Ab0ARMvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0ARMvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739Ab0ARMvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:51:11 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:55246 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0ARMvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YiN6EjV5b8QhU3yoAZiZuBnmSoNXOceQ2yj9z3yO8MmoMKPwAiWlBgJlKyUm3Rsz9J
         ZmeP7fNkPn/Qp1Bwy7LsK97UCXGPM+NN/Nzpn7J90USZgI1mII9HyfFzNYxXIWwhrJdu
         wx0yZKlGHrG+JTU+xQdFCDD67euy1wnwvxSWg=
MIME-Version: 1.0
In-Reply-To: <20100118124419.GC1628@linux.vnet.ibm.com>
References: <1263740593.557.20967.camel@twins>
	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>
	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>
	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>
	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
	 <4B545146.3080001@redhat.com>
	 <20100118124419.GC1628@linux.vnet.ibm.com>
Date: Mon, 18 Jan 2010 14:51:06 +0200
X-Google-Sender-Auth: 53741515c4dcdfce
Message-ID: <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 2:44 PM, Srikar Dronamraju
<srikar@linux.vnet.ibm.com> wrote:
> * Avi Kivity <avi@redhat.com> [2010-01-18 14:17:10]:
>
>> On 01/18/2010 02:13 PM, Pekka Enberg wrote:
>> >So how big chunks of the address space are we talking here for uprobes?
>>
>> That's for the authors to answer, but at a guess, 32 bytes per probe
>> (largest x86 instruction is 15 bytes), so 32 MB will give you a
>> million probes.  That's a piece of cake for x86-64, probably harder
>> to justify for i386.
>
> On x86, each probe takes 16 bytes.

And how many probes do we expected to be live at the same time in
real-world scenarios? I guess Avi's "one million" is more than enough?
