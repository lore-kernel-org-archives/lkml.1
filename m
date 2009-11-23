Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZKWN0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZKWN0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZKWN0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:26:30 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:56028 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZKWN03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:26:29 -0500
Subject: Re: A generic kernel compatibilty code
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <43e72e890911201307g2a1f280aie223ed4fd270aad@mail.gmail.com>
References: <43e72e890911201245r4de5b039hb2dd5011dabf2399@mail.gmail.com>
	 <1258750858.2877.58.camel@achroite.uk.solarflarecom.com>
	 <43e72e890911201307g2a1f280aie223ed4fd270aad@mail.gmail.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Mon, 23 Nov 2009 13:26:33 +0000
Message-Id: <1258982793.2845.13.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2009 13:27:01.0400 (UTC) FILETIME=[A3B90980:01CA6C40]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17026.005
X-TM-AS-Result: No--37.703600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 13:07 -0800, Luis R. Rodriguez wrote:
> On Fri, Nov 20, 2009 at 1:00 PM, Ben Hutchings
> <bhutchings@solarflare.com> wrote:
> > On Fri, 2009-11-20 at 12:45 -0800, Luis R. Rodriguez wrote:
> >> Everyone and their mother reinvents the wheel when it comes to
> >> backporting kernel modules. It a painful job and it seems to me an
> >> alternative is possible. If we can write generic compatibilty code for
> >> a new routine introduced on the next kernel how about just merging it
> >> to the kernel under some generic compat module. This would be
> >> completey ignored by everyone using the stable kernel but can be
> >> copied by anyone doing backport work.
> >>
> >> So I'm thinking something as simple as a generic compat/comat.ko with
> >> compat-2.6.32.[ch] files.
> >>
> >> We've already backported everything needed for wireless drivers under
> >> compat-wireless under this format down to even 2.6.25.
> > [...]
> >
> > If you think 2.6.25 is old then I don't think you understand the scale
> > of the problem.
> >
> > OEMs still expect us to support RHEL 4 (2.6.9) and SLES 9 (2.6.5) though
> > the latter will probably be dropped soon.  Some other vendors apparently
> > still need to support even 2.4 kernels!
> 
> Heh understood. Well shouldn't this help with that then? Sure I'd love
> to see the Enteprise Linux releases on 2.6.31 but that's not going to
> happen right? Shouldn't this help then?

You'd really have to ask the 'enterprise' vendors whether they'd be
interested in working on some sort of shared forward-compat library.  If
the library is to include a module rather than being statically linked
into each module that needs it then there can only be one instance in
the system.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

