Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbXCET2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbXCET2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbXCET2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:28:31 -0500
Received: from mail.kroah.org ([69.55.234.183]:45824 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078AbXCET23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:28:29 -0500
Date: Mon, 5 Mar 2007 11:26:22 -0800
From: Greg KH <greg@kroah.com>
To: "S.??a??lar Onur" <caglar@pardus.org.tr>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/18] 2.6.18-stable review
Message-ID: <20070305192622.GA2768@kroah.com>
References: <20070221014927.GA3684@kroah.com> <200702211355.05539.caglar@pardus.org.tr> <20070226001824.GI29575@stusta.de> <200703051544.24041.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703051544.24041.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 03:44:22PM +0200, S.??a??lar Onur wrote:
> 26 ??ub 2007 Pts tarihinde, Adrian Bunk ??unlar?? yazm????t??: 
> > On Wed, Feb 21, 2007 at 01:55:04PM +0200, S.??a??lar Onur wrote:
> > > 21 ??ub 2007 ??ar tarihinde, Greg KH ??unlar?? yazm????t??:
> > > > Responses should be made by Friday February 23 00:00 UTC.  Anything
> > > > received after that time might be too late.
> > >
> > > We have still some CVEish patches in our package which maybe you want to
> > > consider adding into -stable.
> >
> > Below, I'll only look at the 2.6.18, 2.6.19 and 2.6.20 kernels.
> >
> > > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-4814
> >
> > fixed in:
> > - 2.6.18.8
> > - 2.6.19.2
> > - 2.6.20
> >
> > > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5749
> >
> > fixed in:
> > - 2.6.20 (commit dab6df63086762629936e8b89a5984bae39724f6)
> >
> > missing in:
> > - 2.6.18
> > - 2.6.19
> >
> > > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5753
> >
> > fixed in:
> > - 2.6.20 (commit be6aab0e9fa6d3c6d75aa1e38ac972d8b4ee82b8)
> >
> > missing in:
> > - 2.6.18
> > - 2.6.19
> >
> > > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5823
> >
> > fixed in:
> > - 2.6.19.2
> > - 2.6.20
> >
> > missing in:
> > - 2.6.18
> >
> > > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6053
> >
> > fixed in:
> > - 2.6.19.2
> > - 2.6.20
> >
> > missing in:
> > - 2.6.18
> >
> > > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6054
> >
> > fixed in:
> > - 2.6.19.2
> > - 2.6.20
> >
> > missing in:
> > - 2.6.18
> >
> > > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6333
> >
> > fixed in:
> > - 2.6.19.1
> > - 2.6.20
> >
> > problem not present in:
> > - 2.6.18
> >
> > > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-0006
> >
> > fixed in:
> > - 2.6.19.5
> >
> > missing in:
> > - 2.6.18
> > - 2.6.20
> 
> So maybe 2.6.18 deserves another stable release :) ?

Why?  Does anyone really use it now that 2.6.19 and 2.6.20 is out?

I don't want to do a new release as we need to catch up on the 2.6.20
issues...

And also remember, the point of the -stable tree was that we would drop
older releases after the next release came out.

thanks,

greg k-h
