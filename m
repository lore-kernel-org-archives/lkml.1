Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbXJaRdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbXJaRdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXJaRdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:33:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:35463 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbXJaRdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:33:11 -0400
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, Ram <vshrirama@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: kernel processes - are they really needed?
From: Andi Kleen <andi@firstfloor.org>
References: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com>
	<p73hckgqoxg.fsf@bingen.suse.de>
	<d120d5000710310935i13629beahdc01e775e3cf6aa@mail.gmail.com>
Date: Wed, 31 Oct 2007 18:33:07 +0100
In-Reply-To: <d120d5000710310935i13629beahdc01e775e3cf6aa@mail.gmail.com> (Dmitry Torokhov's message of "Wed\, 31 Oct 2007 12\:35\:31 -0400")
Message-ID: <p73k5p32nqk.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Dmitry Torokhov" <dmitry.torokhov@gmail.com> writes:

> On 10/24/07, Andi Kleen <andi@firstfloor.org> wrote:
>>
>> My favourite for a ridiculous thread was and is "kpsmoused"
>>
>
> Mouse querying can take significant amount of time. Do you really want
> all your other events to be delayed just because kernel tries to get
> mouse back in order?

How long? 

>
> Although I probably want to kill it if mouse resync is disabled...

How often does that happen? Can't you just start a thread for this
as needed? Or if it's a simple algorithm you can just use a state machine
using timers?

-Andi
