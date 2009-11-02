Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbZKBT4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbZKBT4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932251AbZKBT4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:56:35 -0500
Received: from khc.piap.pl ([195.187.100.11]:44951 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262AbZKBT4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:56:34 -0500
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
Date: Mon, 02 Nov 2009 20:56:36 +0100
In-Reply-To: <alpine.DEB.2.00.0911020936500.12321@asgard.lang.hm>
	(david@lang.hm's message of "Mon, 2 Nov 2009 09:39:55 -0800 (PST)")
Message-ID: <m3eioghf9n.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

> fo any individual user it will alsays be a larger download, but if you
> have to support more than one architecture (even 32 bit vs 64 bit x86)
> it may be smaller to have one fat package than to have two 'normal'
> packages.

In terms on disk space on distro TFTP servers only. You'll need to
transfer more, both from user's and distro's POV (obviously). This one
simple fact alone is more than enough to forget the FatELF.

Disk space on FTP servers is cheap (though maybe not so on 32 GB SSDs
and certainly not on 16 MB NOR flash chips). Bandwidth is expensive. And
it doesn't seem to be going to change.

FatELF means you have to compile for many archs. Do you even have the
necessary compilers? Extra time and disk space used for what, to solve
a non-problem?

> yes, the package manager could handle this by splitting the package up
> into more pieces, with some of the pieces being arch independant, but
> that also adds complexity.

Even without splitting, separate per-arch packages are a clear win.

I'm surprised this idea made it here. It certainly has merit for
installation medium, but it's called directory tree and/or .tar or .zip
there.
-- 
Krzysztof Halasa
