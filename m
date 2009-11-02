Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZKBUdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZKBUdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbZKBUdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:33:18 -0500
Received: from khc.piap.pl ([195.187.100.11]:54059 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751AbZKBUdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:33:17 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: david@lang.hm
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?utf-8?Q?M=C3=A5ns_Rullg=C3=A5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
	<20091102000147.424f104b@lxorguk.ukuu.org.uk>
	<alpine.OSX.1.10.0911012023020.55434@caridad.local>
	<20091102091611.60dfeea1@lxorguk.ukuu.org.uk>
	<alpine.DEB.2.00.0911020936500.12321@asgard.lang.hm>
	<m3eioghf9n.fsf@intrepid.localdomain>
	<alpine.DEB.2.00.0911021205540.12321@asgard.lang.hm>
Date: Mon, 02 Nov 2009 21:33:20 +0100
In-Reply-To: <alpine.DEB.2.00.0911021205540.12321@asgard.lang.hm>
	(david@lang.hm's message of "Mon, 2 Nov 2009 12:11:39 -0800 (PST)")
Message-ID: <m3aaz4hdkf.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

>> In terms on disk space on distro TFTP servers only. You'll need to
>> transfer more, both from user's and distro's POV (obviously). This one
>> simple fact alone is more than enough to forget the FatELF.
>
> it depends on if there is only one arch being downloaded ot not.

Well, from user's POV it may get close if the user downloads maybe 5
different archs out of all supported by the distro. Not very typical
I guess.

> it could be considerably cheaper for mirroring bandwidth.

Maybe (though it can be solved with the existing techniques).
What does now count - bandwidth consumed by users or by mirrors?

> Even if Alan
> is correct and distros have re-packaged everything so that the arch
> independant stuff is really in seperate packages, most
> mirroring/repository systems keep each distro release/arch in a
> seperate directory tree, so each of these arch-independant things gets
> copied multiple times.

If it was a (serious) problem (I think it's not), it could be easily
solved. Think rsync, sha1|256-based mirroring stuff etc.

> you don't have to compile multiple arches anymore than you have to
> provide any other support for that arch. FatELF is a way to bundle the
> binaries that you were already creating, not something to force you to
> support an arch you otherwise wouldn't (although if it did make it
> easy enough for you to do so that you started to support additional
> arches, that would be a good thing)

Not sure - longer compile times, longer downloads, no testing.

> if you have a 1M binary with 500M data, repeated for 5 arches it is
> not a win vs a single 505M FatELF package in all cases.

A real example of such binary maybe?
-- 
Krzysztof Halasa
