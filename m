Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZKBTIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZKBTIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbZKBTIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:08:24 -0500
Received: from impaqm1.telefonica.net ([213.4.129.21]:43672 "EHLO
	IMPaqm1.telefonica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbZKBTIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:08:23 -0500
X-TE-authinfo: authemail="i92guboj.terra.es" |auth_email="i92guboj@terra.es"
X-TE-AcuTerraCos: auth_cuTerraCos="cosuitera01"
MIME-Version: 1.0
Date: Mon, 02 Nov 2009 20:08:12 +0100
From: =?UTF-8?Q?Jes=C3=BAs_Guerrero?= <i92guboj@terra.es>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: FatELF patches...
In-Reply-To: <alpine.OSX.1.10.0911021258270.464@caridad.icculuslan>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <20091102000147.424f104b@lxorguk.ukuu.org.uk> <alpine.OSX.1.10.0911012023020.55434@caridad.local> <87zl75h2mh.fsf@sonic.technologeek.org> <alpine.OSX.1.10.0911021258270.464@caridad.icculuslan>
Message-ID: <2ad9fd71b862818ad4ef470cb1798780@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 13:18:41 -0500 (EST), "Ryan C. Gordon"
<icculus@icculus.org> wrote:
>> > software that isn't appropriate for an apt/yum repository
>> 
>> Just create a repository for the damn thing if you want to distribute
it
>> that way. There's no "appropriate / not appropriate" that applies here.
> 
> I can't imagine most people are interested in building repositories and 
> telling their users how to add it to their package manager, period, but 
> even less so when you have to build different repositories for different

> sets of users, and not know what to build for whatever is the next
popular 
> distribution. For things like Gentoo, which for years didn't have a way
to 
> extend portage, what was the solution?

I am not going into the FatELF thing. I am just following the debate
because it's interesting :)

However, for the sake of correctness about Gentoo, 

1)
Gentoo has had support for "overlays" *for ages*. I am sure they were
there when I joined in 2004. So I am not sure why you say that portage
can't be extended. I can't be sure when did overlays get into scene, I have
no idea if they were there from the beginning, but even at that stage, if
nothing else, you could still use the "ebuild" tool directly over an
ebuild, stored at any arbitrary place, not necessarily in the portage tree.
Nowadays there's a great number of well known overlays, where several
Gentoo devs are involved. Some of these are the testbed for trees that are
later incorporated to the official portage tree. A well known example is
sunrise, because it's big and of a great quality, but there are many more.

2)
Gentoo is probably the last distro that would benefit from FatELF, since
it's a distro where each user slims the system down to his/her needs.
Gentoo is not about making things generic. That's what compiling for your
architecture, USE flags, etc. are all about. If there's a distro out there
where FatELF doesn't make any sense at all, that's Gentoo for sure (as a
representative of source distros, I guess the same could apply to LFS,
sourcemage, etc.).

3)
Besides that, the average Gentoo user has no problem rolling his own
ebuilds if needed and putting them into a local overlay. And even if they
lack the skill there's always the forum and bugzilla for that. This is as
last resource, as said, there are *lots* of well known and maintained
overlays out there.

Again, these are not arguments in favor or against FatELF, as said, I am
staying away of the discussion, just some clarifications for things that I
thought are not correct. :)
-- 
Jesús Guerrero
