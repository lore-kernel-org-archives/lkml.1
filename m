Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0BIG5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 01:57:40 -0500
Received: from mail-qy0-f200.google.com ([209.85.221.200]:63601 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0BIG5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 01:57:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Hm1Cp0AeX+zKIftnYZFUb2X+0pGsqEayUM6KAJ/n9e2e9HtfEfrkWXrkFo6L7qdEF2
         5KkdmM1E3bXnRiPtOGm+gJWdlJm9/M64iPzUDApqhfmJDINGO9UrrphQAnyD1lz9m62+
         2G7+06apwHMHVncApqv6/vHoquDuoGbMv1dpo=
MIME-Version: 1.0
In-Reply-To: <20100209042348.GA2558@brick.ozlabs.ibm.com>
References: <20100208184504.GB5130@lenovo>
	 <20100209042348.GA2558@brick.ozlabs.ibm.com>
Date: Tue, 9 Feb 2010 09:57:35 +0300
Message-ID: <aa79d98a1002082257o3883a102y160ff2bb14c2077e@mail.gmail.com>
Subject: Re: [RFC perf,x86] P4 PMU early draft
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/10, Paul Mackerras <paulus@samba.org> wrote:
> On Mon, Feb 08, 2010 at 09:45:04PM +0300, Cyrill Gorcunov wrote:
>
>> The main problem in implementing P4 PMU is that it has much more
>> restrictions for event to MSR mapping. So to fit into current
>> perf_events model I made the following:
>
> Is there somewhere accessible on the web where I can read about the P4
> PMU?  I'm interested to see if the constraint representation and
> search I used on the POWER processors would be applicable.
>
> Paul.
>

I've been using intel sdm, from intel.com
