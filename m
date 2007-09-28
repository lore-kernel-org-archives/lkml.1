Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbXI1OA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbXI1OA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbXI1OAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:00:20 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:50431 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbXI1OAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KHdgdiuxAv4Xsf7JEl4juYbUCr7at2lHsBCntERse7ePMPXs83r7IHe+FR/xOFePUwh5XJeFvxPVO00F+J86TtNboV0U2ghI5k2UZVguZE+W2VXQCC3o4j4H0dAoGDVnI68yEPPiJIJzIgNqp1UiTRXlFjVJ6Heu8FNuRmNvS1M=
Message-ID: <653402b90709280700m19b071bcg5ad4fc13179bfba2@mail.gmail.com>
Date: Fri, 28 Sep 2007 16:00:16 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC] New kernel-message logging API (take 2)
Cc: LKML <linux-kernel@vger.kernel.org>, "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <19f34abd0709280655g3dfb6b32vb4d1bf46757c845a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
	 <19f34abd0709280511h3f31681bh54c6af287a48c02f@mail.gmail.com>
	 <653402b90709280630t4168abc4rd114aaa5747adc09@mail.gmail.com>
	 <19f34abd0709280655g3dfb6b32vb4d1bf46757c845a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On 9/28/07, Miguel Ojeda <maxextreme@gmail.com> wrote:
> > On 9/28/07, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > > reason we can't use KBUILD_MODNAME is that this is defined on the
> > > command line. The declaration inside the header would thus be horribly
> > > wrong. We can, however, use KBUILD_MODNAME as a default value for
> > > KPRINT_DRIVER, like:
> > > static const char *KPRINT_DRIVER = KBUILD_MODNAME;
> > > which would pre-process to something like:
> > > static const char *KPRINT_DRIVER = "bcm43xx";
> > >
> > > This value can still be overridden using #define KPRINT_DRIVER "new
> > > name". In this case, it is possible that the original KPRINT_DRIVER
> > > symbol can cause an "unused variable"-warning. I guess this is fixable
> > > with the gcc "unused" variable attribute.
> >
> > Yep, then, in a year or two, we will be able to delete such attribute.
>
> Actually, no, since it will throw a warning only if a source file
> #defines KPRINT_SUBSYSTEM (i.e. overrides the constant variable
> (oxymoron!) with the same name). What you're hoping is that some time
> in the future, EVERY source file will come equipped with these
> definitions, and yes, at that point, the entire declaration can be
> removed, BUT I think that's... well. Yes.

Yes, that was my point. Far far far away, but possible, and if this
RFC ever meets the real kernel, then bringing every source file to the
API should be a objective. A good project for kernel janitors, for
example.

>
> > Will there be a team to change main subsystems/drivers to the new API?
>
> No. First of all, this is a specification draft; there is no code yet.
> Also, very possibly, this is such a violent change that nobody really
> wants to use it anyway. But we can hope. ;-)

Sure, this is speculation. :)

>
> Vegard
>


-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
