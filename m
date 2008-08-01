Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbYHAWEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbYHAWEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYHAWEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:04:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13187 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYHAWEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=ZGtXAFJynPZOmed+begtLz/xvmhr1bIYCopODU5Rm5gSl4lmrV+45KIt0oElg0q4Zy
         fseQnfvL6h4okRDVsANpx+ZstXXrSN6Yq2KnVZuoRw+AtcHm9KTtWPA/PY1BdQZzV+Dt
         MwU63eUq2JgjMG4cz/QmdGVWEeW/WN/tbaYj4=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
	<m3ljzj60mk.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807301016020.3334@nehalem.linux-foundation.org>
	<m3abfyqgbg.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0808011308470.3277@nehalem.linux-foundation.org>
Date: Sat, 02 Aug 2008 00:04:48 +0200
In-Reply-To: <alpine.LFD.1.10.0808011308470.3277@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Fri, 1 Aug 2008 13:10:25 -0700 (PDT)")
Message-ID: <m3wsj0l7cv.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>> Yes, I see. I was messed, sorry. Your BYTES_LEFT_IN_PAGE works very
>> well, tested.
>> 
>> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
>
> Ok, this latest version _looks_ ok. How well tested is it? I'm a bit 
> nervous by now. Those earlier versions that got committed had all those 
> wrone registers etc.
>
> Anyway, Ack as far as I'm concerned, but..

Well, I have sanity test for it (at http://people.redhat.com/vmayatsk/copy_user_x8664/), 
but unfortunately it shows what I want to see, not the truth. I'm going
to make a large regression testing next week.

-- 
wbr, Vitaly
