Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbZKBULv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbZKBULv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932350AbZKBULu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:11:50 -0500
Received: from mail.lang.hm ([64.81.33.126]:43115 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbZKBULu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:11:50 -0500
Date: Mon, 2 Nov 2009 12:11:39 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: <m3eioghf9n.fsf@intrepid.localdomain>
Message-ID: <alpine.DEB.2.00.0911021205540.12321@asgard.lang.hm>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <20091102000147.424f104b@lxorguk.ukuu.org.uk>
 <alpine.OSX.1.10.0911012023020.55434@caridad.local> <20091102091611.60dfeea1@lxorguk.ukuu.org.uk> <alpine.DEB.2.00.0911020936500.12321@asgard.lang.hm> <m3eioghf9n.fsf@intrepid.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, Krzysztof Halasa wrote:

> david@lang.hm writes:
>
>> fo any individual user it will alsays be a larger download, but if you
>> have to support more than one architecture (even 32 bit vs 64 bit x86)
>> it may be smaller to have one fat package than to have two 'normal'
>> packages.
>
> In terms on disk space on distro TFTP servers only. You'll need to
> transfer more, both from user's and distro's POV (obviously). This one
> simple fact alone is more than enough to forget the FatELF.

it depends on if there is only one arch being downloaded ot not.

it could be considerably cheaper for mirroring bandwidth. Even if Alan is 
correct and distros have re-packaged everything so that the arch 
independant stuff is really in seperate packages, most 
mirroring/repository systems keep each distro release/arch in a seperate 
directory tree, so each of these arch-independant things gets copied 
multiple times.

> Disk space on FTP servers is cheap (though maybe not so on 32 GB SSDs
> and certainly not on 16 MB NOR flash chips). Bandwidth is expensive. And
> it doesn't seem to be going to change.
>
> FatELF means you have to compile for many archs. Do you even have the
> necessary compilers? Extra time and disk space used for what, to solve
> a non-problem?

you don't have to compile multiple arches anymore than you have to provide 
any other support for that arch. FatELF is a way to bundle the binaries 
that you were already creating, not something to force you to support an 
arch you otherwise wouldn't (although if it did make it easy enough for 
you to do so that you started to support additional arches, that would be 
a good thing)

>> yes, the package manager could handle this by splitting the package up
>> into more pieces, with some of the pieces being arch independant, but
>> that also adds complexity.
>
> Even without splitting, separate per-arch packages are a clear win.
>
> I'm surprised this idea made it here. It certainly has merit for
> installation medium, but it's called directory tree and/or .tar or .zip
> there.

if you have a 1M binary with 500M data, repeated for 5 arches it is not a 
win vs a single 505M FatELF package in all cases.

David Lang
