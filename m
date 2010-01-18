Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104Ab0ARMYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0ARMYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680Ab0ARMYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:24:23 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:53082 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab0ARMYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:24:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=STyXeQBcP8uzJUXdwd8InD7MwzKv/3FO9mQUpcVE4cSiESsygVlg+W0LURon1FM8LV
         /69zKSGmGoGNWSzHByN7OfxRYEZ2C4O/I2bHIt+m59eQzuqxfcTDD1MWO+WLIdYuld6a
         tEBIhm+PSPryBlIQHL6ywNSORGbI2Tl2uJRb4=
MIME-Version: 1.0
In-Reply-To: <4B545146.3080001@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <4B53661A.9090907@redhat.com> <1263800752.4283.19.camel@laptop>
	 <4B543F93.3060509@redhat.com> <1263815072.4283.305.camel@laptop>
	 <4B544D7C.2060708@redhat.com> <1263816396.4283.361.camel@laptop>
	 <4B544F8E.1080603@redhat.com>
	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
	 <4B545146.3080001@redhat.com>
Date: Mon, 18 Jan 2010 14:24:19 +0200
X-Google-Sender-Auth: ac671167500e78b2
Message-ID: <84144f021001180424h54ce7970ra7dda2ff8a3be277@mail.gmail.com>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
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

On 01/18/2010 02:13 PM, Pekka Enberg wrote:
>> So how big chunks of the address space are we talking here for uprobes?

On Mon, Jan 18, 2010 at 2:17 PM, Avi Kivity <avi@redhat.com> wrote:
> That's for the authors to answer, but at a guess, 32 bytes per probe
> (largest x86 instruction is 15 bytes), so 32 MB will give you a million
> probes.  That's a piece of cake for x86-64, probably harder to justify for
> i386.

Yup, it's 32-bit that I worry about.
