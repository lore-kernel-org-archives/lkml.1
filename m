Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYJVPV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYJVPV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYJVPVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:21:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:7269 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYJVPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=Bt87xkfzFCQ+KB8EAZi8o9uDG4FSumov+6olC8xBy+aiLdtnjFUeYVsnKmAB//1Gn8
         W69UqXmOptJ9PCod18kthm3nMrRXhUtCfMfzxQPkIzzrgbKmWeVg/jBkle49YhXCLh1E
         O4/GHJ99jiaPMK3pg7cqGhcx2qNWBXXZWDVmU=
Message-ID: <fb412d760810220821m3b27dfeas83fd732406747568@mail.gmail.com>
Date: Wed, 22 Oct 2008 10:21:09 -0500
From: "Hollis Blanchard" <hollis@alumni.cmu.edu>
Reply-To: hollis@alumni.cmu.edu
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: build failure on powerpc with current -git
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Linux kernel" <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <18686.42209.47915.184451@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F8E86B.702@nortel.com>
	 <18685.27030.529655.761257@cargo.ozlabs.ibm.com>
	 <20081021191324.d4810d40.sfr@canb.auug.org.au>
	 <18686.42209.47915.184451@cargo.ozlabs.ibm.com>
X-Google-Sender-Auth: 3b5023b5f8e93d1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Oops, resending in plain text...)

On Tue, Oct 21, 2008 at 10:58 PM, Paul Mackerras <paulus@samba.org> wrote:
>
> Stephen Rothwell writes:
>
> > On Tue, 21 Oct 2008 16:33:10 +1100 Paul Mackerras <paulus@samba.org> wrote:
> > >
> > > It's a bug in older versions of ld (including 2.16.1) that's fixed in
> > > the current version (2.18).  However, this patch appears to work
> > > around the problem - at least, it let me build a 32-bit kernel with a
> > > cross-toolchain including a 2.16.1 ld.  Let me know if this gets it
> > > working for you.
> >
> > With that patch applied I got these errors for a powerpc ppc64_defconfig
> > build (linux-next).
> >
> > /usr/bin/objcopy: Warning: '/dev/null' is not an ordinary file
>
> Hmmm, so do I, and in fact the arch/powerpc/boot/wrapper change now
> seems to be unnecessary with my cross-compile setup (which has ld
> 2.16.1), whereas yesterday I'm sure it got errors.  Weird.
>
> Chris, could you try just the following change (my previous patch
> without the arch/powerpc/boot/wrapper change) and let me know if it
> fixes things with the ld you use?

Works for me.

binutils 2.16.1 is the most recent binutils that will build with
crosstool, so IMHO it's worth supporting. :)

-Hollis
