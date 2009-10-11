Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbZJKK4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbZJKK4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 06:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbZJKK4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 06:56:19 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:60594 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbZJKK4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 06:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cVaJZhlV1DdRSJ+saplEhiVZUHPKt//ks6LzSQSQhlfWzJIp1IADUoMzFHEbcM7cOf
         0VUefI/BMaQZXw1TZA8/9CLEPmnijHe4EPNpbZyY66zDwQ77zTJ6PEkqfn4K9tzmqahm
         3pGPGZGvzG8q0OWEufISajR3VBReOP3hSS4a0=
MIME-Version: 1.0
In-Reply-To: <1255255735.4095.53.camel@johannes.local>
References: <20091011095217.GA2200@darkstar>
	 <1255255735.4095.53.camel@johannes.local>
Date: Sun, 11 Oct 2009 18:55:41 +0800
Message-ID: <a8e1da0910110355xd47767djaabb653e46a12efc@mail.gmail.com>
Subject: Re: NOHZ: local_softirq_pending 08
From: Dave Young <hidave.darkstar@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 6:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2009-10-11 at 17:52 +0800, Dave Young wrote:
>
>> With kernel 2.6.32-rc3-00052-g0eca52a I got following KERN_ERR
>> messages just while using firefox:
>>
>> [  130.527399] NOHZ: local_softirq_pending 08
>
>> Any idea? or known issue?
>
> Are you using b43 (or wl12x1)? If so, it's a known issue, but the driver
> was recently left without an active maintainer in a brouhaha about a bug
> fix.

Yes, I'm using b43. I will test the patch you posted in another thread.

>
> Cf. http://thread.gmane.org/gmane.linux.kernel.wireless.general/39440
>
> Absent proof that mac80211 is safe to run with BHs enabled, the correct
> solution is disabling tasklets around the RX function, unlike all the
> proposed patches. However, Michael thinks it's such a bad solution that
> he has refused to implement it. So far, nobody has bothered to fix the
> drivers.
>
> FWIW, I believe the bug to be in b43 and wl12x1, and not as Michael
> thinks in the stack.
>
> johannes
>
>



-- 
Regards
dave
