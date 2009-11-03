Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZKCSa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZKCSa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZKCSa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:30:28 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:46147 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZKCSa2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:30:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bTw6FwOW81QTpGqy6Pvp1qn3sY6UcHitHKLeFW2bXluqJrpzKH5Napyo96++3wsCSb
         zo+9mD0aPDlMM6D07ye03mXy2r8TJW+0ckoVUddAQzUO8xFaSWd84UZT278NayPf0Ok+
         nNk1+IUZg0ZTaQiWpP0woLuOk6sGw3fTv/MAw=
MIME-Version: 1.0
In-Reply-To: <151663.1257260057@turing-police.cc.vt.edu>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> 
	<1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> 
	<alpine.OSX.1.10.0911011540400.53392@caridad.local> <yw1xhbte0wx0.fsf@unicorn.mansr.com> 
	<alpine.OSX.1.10.0911011623070.55174@caridad.local> <63587.1257137919@turing-police.cc.vt.edu> 
	<alpine.OSX.1.10.0911020012500.56087@caridad.local> <151663.1257260057@turing-police.cc.vt.edu>
From: Matt Thrailkill <matt.thrailkill@gmail.com>
Date: Tue, 3 Nov 2009 10:30:13 -0800
Message-ID: <a91053ef0911031030g46e908c9u1bb1e3235f148480@mail.gmail.com>
Subject: Re: FatELF patches...
To: Valdis.Kletnieks@vt.edu
Cc: "Ryan C. Gordon" <icculus@icculus.org>,
       =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 6:54 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 02 Nov 2009 10:14:15 EST, "Ryan C. Gordon" said:
>
>> I probably wasn't clear when I said "distribution-wide policy" followed by
>> a "then again." I meant there would be backlash if the distribution glued
>> the whole system together, instead of just binaries that made sense to do
>> it to.
>
> OK.. I'll bite - which binaries does it make sense to do so?  Remember in
> your answer to address the very valid point that any binaries you *don't*
> do this for will still need equivalent hand-holding by the package manager.
> So if you're not doing all of them, you need to address the additional
> maintenance overhead of "which way is this package supposed to be built?"
> and all the derivative headaches.
>
> It might be instructive to not do a merge of *everything* in Ubuntu as you
> did, but only select a random 20% or so of the packages and convert them
> to FatELF, and see what breaks. (If our experience with 'make randconfig'
> in the kernel is any indication, you'll hit a *lot* of corner cases and
> pre-reqs you didn't know about...)

I think he is thinking of only having FatELF binaries for binaries and
libraries
that overlap between 32- and 64-bit in a distro install.  Perhaps everything
that is sitting in /lib32 for example could instead be in a FatELF
binaries in /lib,
alongside the 64-bit binary.

A thought I had, that I don't think has come up in this thread:
could it be practical or worthwhile for distros to use FatElf to ship multiple
executables with different compiler optimizations?  i586, i686, etc.
