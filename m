Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbZG3VJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbZG3VJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZG3VJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:09:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:54116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZG3VJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=OMyNUcT5Zk9ieLFq7m3D1A0AmYBKgRcUFxcYji2F0lJRjn75CIKyYj6n323Ylj+yo5
         ZWlB7z/PH1Gdd+OkxANvaj6sV/wJkvdK7Fo1r4TJosnMi3KEpQY2qB0uYlEwhIk831PM
         mY6rk6AQEMdz3DQIDjEzKrFPYLgrhdJV1CV/4=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090730202804.GA13675@redhat.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com>
	 <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com>
	 <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com>
Date: Thu, 30 Jul 2009 23:09:35 +0200
Message-ID: <7c86c4470907301409m5f3efcf8odaae72844a6a0d42@mail.gmail.com>
Subject: Re: perf_counters issue with self-sampling threads
From: stephane eranian <eranian@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       roland <roland@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 10:28 PM, Oleg Nesterov<oleg@redhat.com> wrote:
> On 07/30, Peter Zijlstra wrote:
>>
>> I'll make a patch for F_SETOWN_TID then, unless someone
>> comes up with a better name for the creature ;-)
>
> I think you are right. It is not safe to change the current
> behaviour.
>
I agree. As I said earlier, it is better to just add a new code
path.
