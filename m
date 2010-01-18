Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794Ab0ARMN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0ARMN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406Ab0ARMN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:13:28 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33518 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0ARMN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:13:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JSvCGZYZq75yaL9h86HNOCaI+nYMZYlLq0L1Cc5MoFvfXacFB1YC01xNC9i603Crqz
         iTrdGbfKSz9xjeMrD6PAkdL1YV38hZNtqYPbsf5ZUintSDwXT0e3ecZUfuSsHGrsJRm7
         pEcSWSJVsmqjv+5XOrq2aZ604+D4MFqcE9WQo=
MIME-Version: 1.0
In-Reply-To: <4B544F8E.1080603@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <4B5325CF.5000001@redhat.com> <1263740593.557.20967.camel@twins>
	 <4B53661A.9090907@redhat.com> <1263800752.4283.19.camel@laptop>
	 <4B543F93.3060509@redhat.com> <1263815072.4283.305.camel@laptop>
	 <4B544D7C.2060708@redhat.com> <1263816396.4283.361.camel@laptop>
	 <4B544F8E.1080603@redhat.com>
Date: Mon, 18 Jan 2010 14:13:25 +0200
X-Google-Sender-Auth: 7c5c9fddd76c4d69
Message-ID: <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
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

Hi Avi,

On Mon, 2010-01-18 at 14:01 +0200, Avi Kivity wrote:
>>> Maybe you place no value on uprobes.  But people who debug userspace
>>> likely will see a reason.

On 01/18/2010 02:06 PM, Peter Zijlstra wrote:
>> I do see value in uprobes, I just don't like it mucking about with the
>> address space. Nor does it appear required.

On Mon, Jan 18, 2010 at 2:09 PM, Avi Kivity <avi@redhat.com> wrote:
> Well, the alternatives are very unappealing.  Emulation and single-stepping
> are going to be very slow compared to a couple of jumps.

So how big chunks of the address space are we talking here for uprobes?
