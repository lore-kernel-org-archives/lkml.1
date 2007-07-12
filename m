Return-Path: <linux-kernel-owner+w=401wt.eu-S935184AbXGLVDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935184AbXGLVDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 17:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762110AbXGLVC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 17:02:56 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:4414 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759743AbXGLVCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 17:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BZKKFl1xmMOOhlPI0xu07pKQBjiJ7r9eZ7/thvh5Z5BjtydYUb/zJxLRv1KiT5IXJ/NC7SAMSlLyg4N8X5M/wVmtK1ng46+DprDRgxgxDJv1bpppGON/8L8UxSDKVUAQ6FatT6S/wkZOctn9py8zFguFy8nb1SSBkYkArMGPCd4=
Message-ID: <8bd0f97a0707121402sf1efc17nabb89e40c3e82095@mail.gmail.com>
Date: Thu, 12 Jul 2007 17:02:54 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: [GIT PULL] Blackfin arch fixes (try #2)
Cc: bryan.wu@analog.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <468DF478.1080403@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1183423041.10353.8.camel@roc-laptop> <468A560A.9050801@l4x.org>
	 <8bd0f97a0707031055h7b97c0cerbd2314a2836f7798@mail.gmail.com>
	 <468C053D.9050302@l4x.org>
	 <8bd0f97a0707060022x16732628ofc3c0a6004776cbe@mail.gmail.com>
	 <468DF478.1080403@l4x.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/07, Jan Dittmer <jdi@l4x.org> wrote:
> Mike Frysinger wrote:
> > On 7/4/07, Jan Dittmer <jdi@l4x.org> wrote:
> >> Mike Frysinger wrote:
> >> > On 7/3/07, Jan Dittmer <jdi@l4x.org> wrote:
> >> >> Bryan Wu wrote:
> >> >>> Jie's patch is required because we will release our new Blackfin
> >> toolchain.
> >> >> So, what is the new toolchain version?
> >> >> gcc 4.1.1 (adi 07r1) / binutils 2.17 doesn't seem to work anymore:
> >> >
> >> > we'll post new toolchain binaries in a bit
> >>
> >> Hrm, somehow I don't understand it. On [1] you're
> >> talking about gcc 4.1.2 and binutils 2.17 supporting
> >> the -mcpu switch. But if you download the 2007R1 RC9
> >> toolchain from the Files section of the site (tar.gz)
> >> you actually get 4.1.1 without mcpu support. But the
> >> version string from gcc indicates 07r1.
> >> Care to explain?
> >
> > the syntax of the -mcpu option was extended
>
> But the tar-ball does _not_ contain 4.1.2

the version is irrelevant ... the syntax was extended and backported to 4.1.1

i put together nightly snapshots which you can find here:
http://blackfin.uclinux.org/gf/project/toolchain/frs/?action=index
-mike
