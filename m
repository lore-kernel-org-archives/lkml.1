Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZG1JNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZG1JNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 05:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZG1JNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 05:13:18 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:57321 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZG1JNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 05:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=GlZjnpNFRslTrLMAdD8nHG5/jE9Ioe6pLoYyXvbRhVIdd1FXG4gsE5x7woyGGDJlhp
         7o4TNZpkYqx1QGEz3xXInHWTEGCq3gDIu8ugpVrboF7rdm718hF5T4o0k3cop3Ahv/Ek
         3GRYXWifkMAorRlX4McstR7blHLkXxmLc45Go=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090728085635.GD15310@basil.fritz.box>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <20090727212514.GA25386@basil.fritz.box>
	 <7c86c4470907272213w2ee57080re50dd22a4d73a7e0@mail.gmail.com>
	 <7c86c4470907280151p13e275c0q27a51897351e8e0@mail.gmail.com>
	 <20090728085635.GD15310@basil.fritz.box>
Date: Tue, 28 Jul 2009 11:13:16 +0200
Message-ID: <7c86c4470907280213o66cbd069l1cc16089f9f07bf7@mail.gmail.com>
Subject: Re: perf_counters issue with self-sampling threads
From: stephane eranian <eranian@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Robert Richter <robert.richter@amd.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Tue, Jul 28, 2009 at 10:56 AM, Andi Kleen<andi@firstfloor.org> wrote:
> On Tue, Jul 28, 2009 at 10:51:04AM +0200, stephane eranian wrote:
>> [Reposting the message because of stupid MIME-encoding error on my part]
>> Andi,
>>
>> Looks like SIGPROF is calling _group_send_sig_info(), so I
>> think it is subject to the same problem.
>
> So sounds like a whole class of signals can't be POSIX compliant.
>

Well, the problem is that I don't where to find the POSIX spec that defines
signal types and how they should be handled in multi-threaded programs.
That would be a good starting point.

> Likely others will run into the same problem.
>
> Perhaps should define a new sigaction flag for this to make
> it all explicit.
>
That's probably a clean way of doing this.
