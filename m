Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZKGArj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZKGArj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 19:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZKGAri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 19:47:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50114 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752398AbZKGAri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 19:47:38 -0500
Date: Sat, 7 Nov 2009 00:49:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matteo Croce <technoboy85@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091107004923.01a4fa20@lxorguk.ukuu.org.uk>
In-Reply-To: <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
	<20091003072127.GC21407@elte.hu>
	<40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
	<4AF4526B.4060101@zytor.com>
	<40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009 23:18:06 +0100
Matteo Croce <technoboy85@gmail.com> wrote:

> On Fri, Nov 6, 2009 at 5:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 11/06/2009 06:59 AM, Matteo Croce wrote:
> >> indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction (NOPL).
> >
> > MMX and MMXEXT are hardly hallmarks of i686, which leaves only cmov.

cmov is not i686 either. Its an optional extension that *should* only be
used after you test its available. So gcc "i686" isn't quite "686". There
are of course good reasons for that choice.

> yes, I did some test like gzip, bzip2, lame etc and they give more or less
> the same results of dhrystone

How does that compare to i486. Certainly the old Nat Semi geode seemed to
prefer to be fed i486 code to i586 (and wouldn't of course hack i686).
You might also want to play around with -mtune= as well as arch= before
assuming why i686 is a win

(I still btw think the patch is a good idea, it simplifies life
enormously for users with the CPU)

Alan
