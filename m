Return-Path: <linux-kernel-owner+w=401wt.eu-S935524AbYEUNfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935524AbYEUNfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933095AbYEUNfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:35:00 -0400
Received: from saeurebad.de ([85.214.36.134]:41312 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761398AbYEUNe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:34:59 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: Tracking and crediting bug reporters
References: <4388.1210613272@vena.lwn.net> <20080521104145.GB4948@ucw.cz>
Date: Wed, 21 May 2008 15:34:35 +0200
In-Reply-To: <20080521104145.GB4948@ucw.cz> (Pavel Machek's message of "Wed,
	21 May 2008 12:41:45 +0200")
Message-ID: <87r6bv4w7o.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Pavel Machek <pavel@ucw.cz> writes:

> Hi!
>
>> So here's what we would like to try instead.  Whenever somebody sends up a
>> patch fixing a reported bug, the name of the person who reported the bug
>> would be immortalized with this tag:
>> 
>> 	Reported-by: A. Bug Reporter <email@goes.here>
>> 
>> In particular, reporters who work with the developers toward the resolution
>> of the bug should be thanked in this way.  If we wanted to take things
>
> I believe we have enough tags already. Plus, if the reporter really
> works with the developer till the end, there's already accepter
> Tested-by: flag, right?

I would more argue to remove Tested-by completely because it does not
tell much.  Code is not bugfree just because someone compiled and ran
it.  And if it breaks on some other systems later on, what does it help
if you know someone tested it?  It still breaks.  And you can not even
blame the tester because of his luck of a working configuration.

While a Reported-by in this case credits a person reporting a bug.  Just
that.  And perhaps that the report was good enough to make a fix.

	Hannes
