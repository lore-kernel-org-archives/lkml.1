Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbXDZXYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbXDZXYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbXDZXYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:24:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:40777 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbXDZXYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=s4NxG5ToWXWhGVtGUDKtMAkwFC1SJiCTabT3XQ7SqSWvTU6ubC+Mkaq6yshMn/gBAA5WeO8jDKEEpzmMpY1yv15S+t9MhWSMrQNCx3kYcLoRpwfRTtLIRRuCXaDPbAqaXfXZRRV5B2J3lNvXzyc1Qj9rrSOAE8bYLnX/IlLgVLg=
Message-ID: <463134A9.7020001@gmail.com>
Date: Fri, 27 Apr 2007 01:24:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: johann deneux <johann.deneux@gmail.com>, linux-kernel@vger.kernel.org,
       stenyak@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC 1/2] Input: ff, add FF_RAW effect
References: <210731960111436322@karneval.cz> <462688AB.4060707@gmail.com>	 <38b3b7c0704182125q1928c5barad21ed603088ab04@mail.gmail.com>	 <200704190058.11625.dtor@insightbb.com> <46278CDD.2000007@gmail.com>	 <d120d5000704190902o60aa4b19y77728585e22b2e84@mail.gmail.com>	 <4af2d03a0704220557u5d6368a2t13878b73bf9dbe64@mail.gmail.com> <d120d5000704260902h7950b30bi7a5a604c16f23421@mail.gmail.com>
In-Reply-To: <d120d5000704260902h7950b30bi7a5a604c16f23421@mail.gmail.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov napsal(a):
> On 4/22/07, Jiri Slaby <jirislaby@gmail.com> wrote:
>> I think we won't be able to make the transition in independent way
>> due to unspecified meaning of the torques.
>>
> 
> With phantom it still seems doable - if I understand correctly ther is
> one point of containct and one resulting vector of forces applied to
> user's hand. With the glove there are multiple points of contact and
> multiple feedback effects applied to different part of hand
> simultaneously and that is for sure requires special application.

Hi.

Good news are, that I've got openhaptics (OS independent layer for sensable
devices) under academic license (I don't know, what the "open" word in that name
means -- no sourcecodes; licensed), the bad ones are, that they use ioctl
approach for both reporting and FF.

Furthermore I tried phantom with input layer in X and realized, that it's needed
to compute real axies from that numbers and that's what I'm doing in userspace
with doubke precision.

Ok, so the question is if the old ioctl approach (something which I posted as a
first patch before we ever starrted to talk about FF and input layer without
mmaping anything to US) is acceptable alone (this is what is needed for
OHaptics) or at least some particular computing to convert the numbers and
reporting to input layer should be implemented (which will have no users anyway,
who will ever want to have 60000$ pointer ;))?

thanks a lot,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
