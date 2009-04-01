Return-Path: <linux-kernel-owner+w=401wt.eu-S1764894AbZDAM5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764894AbZDAM5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764856AbZDAM5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:57:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:36437 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764843AbZDAM5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,306,1235980800"; 
   d="scan'208";a="126579039"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Oleg Nesterov <oleg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Wed, 1 Apr 2009 13:56:58 +0100
Subject: RE: [patch 0/21] x86, ptrace, bts, hw-branch-tracer: fixes and
	cleanups
Thread-Topic: [patch 0/21] x86, ptrace, bts, hw-branch-tracer: fixes and
	cleanups
Thread-Index: Acmyv3lxUtUUmj6ASeW37Y/1M/ZVNgACHTrA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E926D539D@irsmsx504.ger.corp.intel.com>
References: <20090331144229.A11867@sedona.ch.intel.com>
 <20090331233958.GA28228@redhat.com>
 <928CFBE8E7CB0040959E56B4EA41A77E926D4FDE@irsmsx504.ger.corp.intel.com>
 <20090401114557.GC23678@elte.hu>
In-Reply-To: <20090401114557.GC23678@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Wednesday, April 01, 2009 1:46 PM
>To: Metzger, Markus T


>> >> The first 5 patches apply to .29 with the small preparation patch below.
>> >
>> >Tried to review these patches.
>> >
>> >As I said, I don't understand ds.c, but I _think_ these changes are good.
>> >
>> >I only have a couple of really minor nitpicks...
>>
>> Thanks for your review!
>> I will address the nitpicks in separate patches, if that's OK with everyone.
>
>Please dont forget to propagate Oleg's Reviewed-by (or Acked-by)
>tags into the commits.
>
>> Regarding bisecting, I split the patches to attract reviewers to
>> the smaller parts rather than scare them off with one big patch.
>>
>> I hope that the bisecting tool can cope with broken builds between
>> patches.
>
>It cannot, and even if it did we dont want a single intentionally
>broken bisection point in the kernel. Please do small patches that
>build fine at each step. We've got more than 100,000 bisectable
>commits in the kernel to look at. If you think it's not possible in
>a specific case then please describe the situation to us so that we
>can suggest a solution.

I can resend the series with fewer but bigger patches that compile OK.

I'm currently using quilt to manage patches.
I use git to get the sources, but that's it. I send all the patches manually.

You mentioned in another email that I should use "git format-patch" and
"git send-email" and that I should propagate Oleg's acks into the commit
logs.

Is there a way to do this with quilt, as well?
Could you point me to some getting-started documentation?


thanks and regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

