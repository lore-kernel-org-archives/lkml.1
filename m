Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbXKMN7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbXKMN7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXKMN7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:59:00 -0500
Received: from rtr.ca ([76.10.145.34]:1692 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbXKMN67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:58:59 -0500
Message-ID: <4739ADA2.4060604@rtr.ca>
Date: Tue, 13 Nov 2007 08:58:58 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Natalie Protasevich <protasnb@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-input@atrey.karlin.mff.cuni.cz, bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org>
In-Reply-To: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 12 Nov 2007 22:42:32 -0800 "Natalie Protasevich" <protasnb@gmail.com> wrote:
..
>> with CONFIG_NO_HZ and/or CONFIG_HPET_TIMER set kernel 2.6.23 doesn't
>> boot (ARM, Timer)
>> http://bugzilla.kernel.org/show_bug.cgi?id=9229
>> Kernel: 2.6.23
> 
> No response from developers
..

Note:  that same bug exists/existed on i386 back when NO_HZ was
introduced (2.6.21?).  I still see it from time to time on my Quad core
system (very rare), but not any more on my Duo notebook where it used
to happen about 1 in n boots (n < 10).

AFAICT no fix was ever released for it.



>> Suspend to RAM resume hangs on a tickless (NO_HZ) kernel
>> http://bugzilla.kernel.org/show_bug.cgi?id=9275
>> Kernel: 2.6.23
>> This is HP notebook nc6320 T2400 945GM
> No response from developers
..

I *still* get very slow resume-from-RAM quite often here
(new in 2.6.22 kernel, wasn't there in early 2.6.23-rc*).
Something eventually times out after a minute or so
and it comes back.  Cannot make it happen reliably,
unless I'm in a hurry to get something done.  :)
I suspect USB here, probably the same loopy bug that
we added a "loop limit failsafe" for back in 2.6.21(?).
