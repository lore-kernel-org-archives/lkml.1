Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbYEHH3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbYEHH3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbYEHH3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:29:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:39064 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbYEHH3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=giIJsicLt9+xPlFrrcZ5ZaYUIDiolFD1tf3JC80sW2i4ZmvGGdNFgHP0qs2BZSYkucGJPsviACXfO/ArE4RqcvCs5A6Eu7HWX1x6s0LuH9EqjoTrv8l9W27g/o0qJOUuVWKTBqZ9yVLAdpibCUZojrPQ+Uc0YxqwLmMrAn3Uo/8=
Message-ID: <19f34abd0805080029w1415b7jc4edd2772f7086e4@mail.gmail.com>
Date: Thu, 8 May 2008 09:29:34 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Lin Ming" <ming.m.lin@intel.com>
Subject: Re: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Bob Moore" <robert.moore@intel.com>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1210229802.23330.4.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0805060909q635d2d43j9414e5f179c9e22f@mail.gmail.com>
	 <84144f020805061338yd6e3declaf5ff9ca344c28ba@mail.gmail.com>
	 <19f34abd0805061346q4af7e4f8kd65009f8d3021d0e@mail.gmail.com>
	 <4820C56C.6070204@cs.helsinki.fi>
	 <19f34abd0805071221o236c8629ib184a4720f178e7b@mail.gmail.com>
	 <1210224923.22503.8.camel@minggr.sh.intel.com>
	 <19f34abd0805072305i19dc37bn3e13fbca4b6981e3@mail.gmail.com>
	 <1210227145.23183.7.camel@minggr.sh.intel.com>
	 <19f34abd0805072331i2a33ee7bl940d46c478cc62d9@mail.gmail.com>
	 <1210229802.23330.4.camel@minggr.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 8:56 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>  > >  On Thu, 2008-05-08 at 08:05 +0200, Vegard Nossum wrote:
>  > >  > Hello,
>  > >  >
>  > >  > On Thu, May 8, 2008 at 7:35 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>  > >  > > Here comes a simple patch that fixes the warning in my machine.
>  > >  > >
>  > >  > >  Vegard, would you please help to test it in your machine?
>  > >  > >
>  > >  >
>  > >  > Thanks for the try, but unfortunately this does not solve the problem.
>  > >
>  > >  It's strange.
>  > >  In my machine, without this patch the warning shows up
>  > >  With this patch applied the waring goes away
>  >
>  > Ah. That is strange indeed.
>  >
>  > >  Would you please upload the acpidump file?
>  >
>  > Which file is this or how can I produce it? Please tell me the exact
>  > parameters to pass to the command line.
>
>  Please download acpidump util from
>  http://kernel.org/pub/linux/kernel/people/lenb/acpi/utils/pmtools-20071116.tar.bz2
>
>  Run "acpidump > acpidump.out" as root
>
>  Then upload acpidump.out to somewhere I can access
>
>  Lin Ming

You can find it here:
http://userweb.kernel.org/~vegard/bugs/20080508-acpi/

(When running acpidump I got some message, now gone from the screen
unfortunately, but it said something like 0B checksum failed? Hm,
well, it seemed to produce the file anyway.)

Hope this helps. Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
