Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZGaL7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZGaL7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 07:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZGaL7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 07:59:40 -0400
Received: from d1.icnet.pl ([212.160.220.21]:60447 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZGaL7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 07:59:39 -0400
Message-ID: <4A72DC71.6020904@tis.icnet.pl>
Date: Fri, 31 Jul 2009 13:58:41 +0200
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System
User-Agent: IceDove 1.5.0.14pre (X11/20080304)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jarkko Nikula <jhnikula@gmail.com>,
       Jonathan McDowell <noodles@earth.li>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>, alsa-devel@alsa-project.org,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>
Subject: Re: [RFC] [PATCH 3/3 v2] ASoC: add support for Amstrad E3 (Delta)
 machine
References: <200907291318.54897.jkrzyszt@tis.icnet.pl> <20090731095234.GB10844@rakim.wolfsonmicro.main>
In-Reply-To: <20090731095234.GB10844@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Jul 29, 2009 at 01:18:53PM +0200, Janusz Krzysztofik wrote:
> 
>> 2) patch 2/3 form this series: TTY: Add definition of a new line
>>    discipline required by Amstrad E3 (Delta) ASoC driver[2].
> 
> The ASoC parts of this all look OK - what's the status of the TTY patch?
> 

Alan replied off-list yet before v2 submission. Then I replied him 
off-list as well... I hope he doesn't mind quoting him here.

Janusz Krzysztofik wrote:
> Alan Cox wrote:
>> Interesting use of a line discipline. The tty/ldisc bits look good to me
>>
> 
> Thanks.
> Could you please have a look at today's version 2 of the patch 3/3 as 
> well? The ldisc bits has been split into machine and codec related parts 
> and, what's more important, updated with locking that I am not quite 
> sure about its correctness.
> 
> Furthermore, I am still thinking about renaming the ldisc with a more 
> generic name. That way, it could be probably reused by other similiar 
> implementations. As long as the ldisc is registered from a board 
> specific code, it should not interfere with other implemnetations 
> reusing the same ldisc number, even if compiled in side by side.

Any objections on renaming ldisc from N_AMSDLETA to N_V253?

Thnaks,
Janusz

