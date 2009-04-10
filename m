Return-Path: <linux-kernel-owner+w=401wt.eu-S934191AbZDJKuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191AbZDJKuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762832AbZDJKud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:50:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:60779 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454AbZDJKuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E+mzSO+aSjIFgT4PNPUvDOiKW1Qht7j+0FjVCk9k2ZLx9bz7MRsD0ifVOIvVGe3wuZ
         CZvwHXBhATUytvMHJH1iq2zuMysRU1SigPXSnGY61/DNug3Rixqug7ApT6c6tpccQqeb
         FSlY06oisYX4brPYlL0TsES+P6iMA/W7MFytM=
MIME-Version: 1.0
In-Reply-To: <20090410104913.GA21483@uranus.ravnborg.org>
References: <20090408003921.GA5054@ldl.fc.hp.com>
	 <20090408054612.GA6744@ldl.fc.hp.com>
	 <20090407225457.86f8a458.akpm@linux-foundation.org>
	 <20090409003308.GK16602@bilbo.ozlabs.org>
	 <20090408174443.79e71503.akpm@linux-foundation.org>
	 <20090409215207.GN16602@bilbo.ozlabs.org>
	 <20090409234750.GE7921@lug-owl.de> <20090410101220.GF7921@lug-owl.de>
	 <8bd0f97a0904100319kb16c81bs596341e016cc41a@mail.gmail.com>
	 <20090410104913.GA21483@uranus.ravnborg.org>
Date: Fri, 10 Apr 2009 06:50:30 -0400
Message-ID: <8bd0f97a0904100350tf8804dfp2345824a52620961@mail.gmail.com>
Subject: Re: cross-compilers
From: Mike Frysinger <vapier.adi@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 06:49, Sam Ravnborg wrote:
> On Fri, Apr 10, 2009 at 06:19:21AM -0400, Mike Frysinger wrote:
>> On Fri, Apr 10, 2009 at 06:12, Jan-Benedict Glaw wrote:
>> > On Fri, 2009-04-10 01:47:50 +0200, Jan-Benedict Glaw wrote:
>> >> I've started a build-bot like script for binutils + GCC from CVS/GIT.
>> >> If it builds through, I'll start uploading i686 hosted compilers
>> >> later on today.
>> >
>> > So... I've now build trunk kernel-only cross-compilers (hosted on
>> > i686) for these targets:
>> >
>> >        bfin-uclinux.tar.bz2
>>
>> we already host up-to-date Blackfin compilers on the Blackfin website:
>> http://blackfin.uclinux.org/gf/project/toolchain/frs/
>>
>> and we build for a variety of platforms ... atm that is x86, x86_64,
>> ia64, and ppc
>>
>> we also provide for simple distro integration:
>>  - Gentoo has ebuilds in-tree
>>  - deb based distros can use "deb
>> http://download.analog.com/27516/distros/debian stable main"
>>  - rpms are available at the link above (fedora/suse/etc...)
>>  - tarballs are available at the link above (everyone else)
>>
>> not sure it can get much easier than that for installing the Blackfin
>> toolchain ;)
>
> It can...
> I'm after a one-stop place where we can locate cross compilers
> for all architectures that Linux supports so it is a much simpler
> task to actaully try to build our changes for as many architectures
> as we supports.
>
> And please host them on kernel.org - preferably as an update
> of Vegards pages.

whoever is maintaining the one location should simply mirror our
tarballs (grabbing the 1 uclinux from the Debian link would be
easiest) ... unlike the random ones people are compiling and posting,
the binaries we post have gone through extensive testing -- both in
terms of included testsuites (gcc/binutils/etc...) as well as actually
building/running the kernel and userspace
-mike
