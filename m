Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYABVvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYABVvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYABVu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:50:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21972 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYABVu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:50:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=c30cJKukUeUvEnIg2b+dwJhWqewHrIwkYjfUtWHnBBXfegHoSC2aLl4/UWgYvX33E
	VKI+b2sUR0ELXn/ut0o4g==
Message-ID: <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com>
Date: Wed, 2 Jan 2008 13:50:48 -0800
From: "Russell Leidich" <rml@google.com>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, valdis.kletnieks@vt.edu
In-Reply-To: <64bb37e0801021333g3cccff81k68df75463e4a21d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071217185453.C4597CC562@localhost>
	 <20071225140413.e8b4f2cd.akpm@linux-foundation.org>
	 <3f1a065b0712271057s150b62f8nb11ebc28dc55f811@mail.gmail.com>
	 <20071227233419.d1adf3f3.akpm@linux-foundation.org>
	 <3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com>
	 <p731w9410yc.fsf@bingen.suse.de>
	 <3f1a065b0801021143y5fc15e29r4201ac19bc7c1daa@mail.gmail.com>
	 <20080102200039.GA13784@one.firstfloor.org>
	 <3f1a065b0801021312w6f823cbeh9ea6b73d2b0c46c8@mail.gmail.com>
	 <64bb37e0801021333g3cccff81k68df75463e4a21d0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 2, 2008 1:33 PM, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> On Jan 2, 2008 10:12 PM, Russell Leidich <rml@google.com> wrote:
> > On Jan 2, 2008 12:00 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > > On Wed, Jan 02, 2008 at 11:43:08AM -0800, Russell Leidich wrote:
> > > > likelihood, will extend to some future CPUs).  Indeed, as far as my
> > > > testing has determined, there is no stepping of K8s which properly
> > > > implements thermal throttling.  Even Rev F has a crippling erratum.
> > >
> > > How about RevG?
> >
> > I don't know of any RevG.  Please explain.
>
> http://products.amd.com/en-us/DesktopCPUResult.aspx?f1=&f2=&f3=&f4=&f5=AM2&f6=G1&f7=65nm+SOI&f8=&f9=&
> http://products.amd.com/en-us/DesktopCPUResult.aspx?f1=&f2=&f3=&f4=512&f5=AM2&f6=G2&f7=65nm+SOI&f8=&f9=&
>
> 65nm Athlons come in G1 and G2 steppings.

Thanks.  My code doesn't support these CPUs because their northbridge
IDs are not 0x1203.

>
> HTH
>
> Torsten
>



-- 
Russell Leidich
