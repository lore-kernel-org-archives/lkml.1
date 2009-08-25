Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZHYUDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZHYUDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbZHYUDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:03:49 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:34528 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756089AbZHYUDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:03:49 -0400
Message-ID: <4A9443A3.8030706@nets.rwth-aachen.de>
Date: Tue, 25 Aug 2009 22:03:47 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Execute WP test after interrupts are enabled
References: <1251227779-24347-1-git-send-email-penberg@cs.helsinki.fi> <4A943CBD.60808@goop.org> <1251229085.25686.2.camel@penberg-laptop> <4A94411E.708@goop.org>
In-Reply-To: <4A94411E.708@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge schrieb:
> On 08/25/09 12:38, Pekka Enberg wrote:
>> On Tue, 2009-08-25 at 12:34 -0700, Jeremy Fitzhardinge wrote:
>>
>>> I don't think this is the real fix, and it seems a bit ugly.  I'm
>>> OK with it as a workaround, but I think it will end up getting
>>> reverted if applied.
>>>
>> Yeah, I'm fine with that. It's just that we're really late in the
>> release cycle now so I'd like to keep the fix as simple as
>> possible.
>
> Yeah, that's fine, but I think something like this would be simpler.
>  Arnd, could you test it please?

Yes, this indeed also fixes my problem.


Best regards,
Arnd
