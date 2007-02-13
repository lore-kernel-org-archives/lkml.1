Return-Path: <linux-kernel-owner+w=401wt.eu-S1750763AbXBMPzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750763AbXBMPzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbXBMPzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:55:33 -0500
Received: from rtr.ca ([64.26.128.89]:2053 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXBMPzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:55:32 -0500
Message-ID: <45D1DF66.6030906@rtr.ca>
Date: Tue, 13 Feb 2007 10:55:18 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tilman Schmidt <tilman@imap.cc>,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
References: <1171058269.1484.64.camel@nigel.suspend2.net>	 <1171147026.19894.16.camel@nigel.suspend2.net> <45CE5934.3020801@imap.cc>	 <200702110127.35631.rjw@sisk.pl> <1171233683.4493.81.camel@nigel.suspend2.net>
In-Reply-To: <1171233683.4493.81.camel@nigel.suspend2.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> On Sun, 2007-02-11 at 01:27 +0100, Rafael J. Wysocki wrote:
>> Plus:
>> - What if I'm planning to implement the power managemet, but not just right
>> now?
> 
> Why not right now?

LKML is much more receptive to drivers that follow
the "release early, release often" mantra.

Which means we really have to be more accomodating of
drivers that start out simple, and then gain all of the
non-essential capabilities gradually over time.

Simple observation here shows much more hostility :)
to drivers that are simply "presented" as a complete whole.
Often for good reason -- starting out with a framework
and then adding the rest bit by bit allows for much better
peer review and feedback.

And not all devices / situations need power management,
and lack of documentation on the hardware often prevents
us from implementing it at the outset.

Cheers
