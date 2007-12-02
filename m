Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbXLBEDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbXLBEDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 23:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbXLBECz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 23:02:55 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48669 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbXLBECy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 23:02:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Albert Cahalan" <acahalan@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Guillaume Chazarain" <guichaz@yahoo.fr>,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, oleg@tv-sign.ru,
       rjw@sisk.pl, roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org>
	<20071128014901.4b303954@inria.fr>
	<787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com>
	<20071128104622.GB19694@elte.hu>
	<m1ve7mehcm.fsf@ebiederm.dsl.xmission.com>
	<787b0d920711280947g418330faie5c96293102c3f05@mail.gmail.com>
	<m1hcj4buim.fsf@ebiederm.dsl.xmission.com>
	<787b0d920711292344y43c9bc1cs2505a800617ecf86@mail.gmail.com>
Date: Sat, 01 Dec 2007 21:00:20 -0700
In-Reply-To: <787b0d920711292344y43c9bc1cs2505a800617ecf86@mail.gmail.com>
	(Albert Cahalan's message of "Fri, 30 Nov 2007 02:44:12 -0500")
Message-ID: <m1hcj13fvv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Albert Cahalan" <acahalan@gmail.com> writes:

>> >> >> This one is probably best:
>> >> >> /proc/task -> 123/task/456
>> >> >> (with both numbers showing)
>> >> >
>> >> > this sounds good to me. If it's a symlink then there's not much other
>> >> > choice because the thread PIDs do not even show up under /proc anymore.
>> >>
>> >> The name sounds good to me.
>>
>> I will see about writing the patch for this in a bit and sending
>> it to Andrew.
>
> Nice.

Actually I think I will call it /proc/current.  That names seems to convey
a little better what we are after.

Eric
