Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555Ab0ANC1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0ANC1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792Ab0ANC1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:27:21 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:57689 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0ANC1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XiaQXYD9mjXNP62iiX+EB7zS6NmzzO4MtIgXMC0vu3ypdjf1IYquK5NCW0leaSrEB4
         QYBqDvjJZi1GQOaCr1G7xKSOKDEpk0TrL7P1t7AFmMuDU+oiqvkTjOhtWS6ocqEbh9ey
         VKhhNBhhHUylqkdi1QFBwVsYulRRGeMJTY/hw=
MIME-Version: 1.0
In-Reply-To: <87ljg1fn3u.fsf@basil.nowhere.org>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com>
	 <87ljg1fn3u.fsf@basil.nowhere.org>
Date: Wed, 13 Jan 2010 18:21:20 -0800
Message-ID: <bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com>
Subject: Re: HW breakpoints perf_events request
From: Joshua Pincus <joshua.pincus@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 13, 2010 at 6:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Joshua Pincus <joshua.pincus@gmail.com> writes:
>
>> I have a request for an additional feature to be included
>> in the recent hardware breakpoints work soon to be delivered
>> in kernel 2.6.33.
>
> Sounds to me like the existing ptrace based interface
> can practically all you want
>
> (except that the "parent signal" would be wait and for
> fork/exec you have to explicitely attach)

We would like to avoid using ptrace at all costs.
It requires us to have a parent thread running
which monitors all the others.  It's not clear that
the wait() call by the parent doesn't mask a barrage
of signals from various threads and the performance
penalty is huge in multi-threaded apps.

If we could get this functionality working w/o ptrace,
we'd be very, very happy and grateful.

>
> -Andi
>

Thanks,
JP
--
On Wed, Jan 13, 2010 at 6:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Joshua Pincus <joshua.pincus@gmail.com> writes:
>
>> I have a request for an additional feature to be included
>> in the recent hardware breakpoints work soon to be delivered
>> in kernel 2.6.33.
>
> Sounds to me like the existing ptrace based interface
> can practically all you want
>
> (except that the "parent signal" would be wait and for
> fork/exec you have to explicitely attach)
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
