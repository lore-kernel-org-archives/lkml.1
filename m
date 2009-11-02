Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbZKBRnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbZKBRnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:43:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbZKBRnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:43:01 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39378 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750926AbZKBRnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:43:00 -0500
Date: Mon, 2 Nov 2009 17:44:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: david@lang.hm
Cc: "Ryan C. Gordon" <icculus@icculus.org>,
       =?ISO-8859-14?B?TeVucyBSdWxs?= =?ISO-8859-14?B?Z+VyZA==?= 
	<mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
Message-ID: <20091102174436.27bb467f@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.0911020936500.12321@asgard.lang.hm>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley>
	<yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
	<20091102000147.424f104b@lxorguk.ukuu.org.uk>
	<alpine.OSX.1.10.0911012023020.55434@caridad.local>
	<20091102091611.60dfeea1@lxorguk.ukuu.org.uk>
	<alpine.DEB.2.00.0911020936500.12321@asgard.lang.hm>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> how much of the package is binary executables (which get multiplied) vs 
> how much is data or scripts (which do not)

IFF the data is not platform dependant formats.

> fo any individual user it will alsays be a larger download, but if you 
> have to support more than one architecture (even 32 bit vs 64 bit x86) 
> it may be smaller to have one fat package than to have two 'normal' 
> packages.

Nope. The data files for non arch specific material get packaged
accordingly. Have done for years.

> 
> yes, the package manager could handle this by splitting the package up 
> into more pieces, with some of the pieces being arch independant, but that 
> also adds complexity.

Which was implemented years ago and turns out to be vital because only
some data is not arch specific.
