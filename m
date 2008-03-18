Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYCST13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYCST13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYCSTZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:25:17 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:59419 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYCSTZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:05 -0400
To: Jeff Dike <jdike@addtoit.com>
Cc: clowncoder <vincent-perrier@club-internet.fr>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@timesys.com>
Subject: Re: [2.6.24.x] UML select()/poll() oversleeping reproducibly
References: <47B34BA0.30006@club-internet.fr>
	<20080214003853.GA15952@c2.user-mode-linux.org>
	<47B4BDCD.4080605@club-internet.fr>
	<20080215160205.GA6082@c2.user-mode-linux.org>
	<47B5CE40.9000005@club-internet.fr>
	<20080215184650.GA8810@c2.user-mode-linux.org>
	<87y78kx640.fsf_-_@hades.wkstn.nix>
	<20080317193415.GA12234@c2.user-mode-linux.org>
	<87k5k112kf.fsf@hades.wkstn.nix>
	<20080318170019.GA8747@c2.user-mode-linux.org>
From: Nix <nix@esperi.org.uk>
Emacs: an inspiring example of form following function... to Hell.
Date: Tue, 18 Mar 2008 19:39:06 +0000
In-Reply-To: <20080318170019.GA8747@c2.user-mode-linux.org> (Jeff Dike's message of "Tue, 18 Mar 2008 13:00:19 -0400")
Message-ID: <87wsnzrfdx.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-INFN-TO-Metrics: hades 1233; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 Mar 2008, Jeff Dike outgrape:

> Below is another patch.
>
> I was hurt and disappointed by your
>> Eeuuuuw. :)
> so I got rid of the 9/10 thing.

Yay! That's much less dependent on the exact nature of whatever the
underlying bug is :) a random 9/10, well, it just makes my skin itch
even if it does work (unless there turned out to be a fundamental reason
why 9/10 was the right value, that is).

> This version keeps track of the time between ticks (as reported by the
> host's gettimeofday) and adjusts its sleeping and reporting ticks
> accordingly.
>
> It's still undersleeping a little - your little test once reported 19
> seconds for a 20 second sleep.  Otherwise, it's reporting sleep times
> that are right on the money.

I think we can live with that. Expecting perfect accuracy, even in a
sleep, is hopeless unless we're niced to realtime priority in any case,
and this looks like it should automatically adapt to varying load on
the host as well, which is really quite neat.

I'll give it an acid test (does ISC dhclient work now?) in a few hours,
when I can afford to drop offline.

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
