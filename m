Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbZAGQEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbZAGQEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZAGQER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:04:17 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:54646 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbZAGQEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:04:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HES6UnFdaG6+7pzH3qHdbLgrXzwRMI8SwnfVe2NpD+xo9Z1gsvY4brVAguxlk7tfwL
         6Te+AcwhqQgqNdnrJInFAJCuMWMglmrmjBQbFeInjI693fDQWLnK0r6x+Ibv6sZDE5jx
         1Mg32NePM+MN5UjgIGkGW/kaZYQXIWCV6RZHk=
Message-ID: <1f1b08da0901070804t163e111fj6664adbfc5f3a76e@mail.gmail.com>
Date: Wed, 7 Jan 2009 08:04:14 -0800
From: "john stultz" <johnstul@us.ibm.com>
To: mayer@ntp.isc.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: linasvepstas@gmail.com, david@lang.hm, "Robert Hancock" <hancockr@shaw.ca>,
       "Ben Goodger" <goodgerster@gmail.com>,
       "Kyle Moffett" <kyle@moffetthome.net>,
       MentalMooMan <slashdot@jameshallam.info>,
       "David Newall" <davidn@davidnewall.com>, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, "Travis Crump" <pretzalz@techhouse.org>,
       burdell@iruntheinter.net, "Nick Andrew" <nick@nick-andrew.net>,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>
In-Reply-To: <4964BD76.9090700@ntp.isc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495F0672.6020708@davidnewall.com>
	 <49614835.7000505@davidnewall.com>
	 <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	 <20090105143335.GC18055@mail.local.tull.net>
	 <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
	 <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
	 <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
	 <49642674.9080703@ntp.isc.org>
	 <3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
	 <4964BD76.9090700@ntp.isc.org>
X-Google-Sender-Auth: 9b307ddecec90c80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 6:34 AM, Danny Mayer <mayer@ntp.isc.org> wrote:
> I'd much rather you spend the time tackling the clock interrupt losses
> that many of our Linux users complain about. See:
> https://support.ntp.org/bin/view/Support/KnownOsIssues#Section_9.2.4.
> for some of the gorier details. I'm sure you don't really want us
> recommending that they set HZ=100 in the kernel to alleviate the problem.

I believe the lost tick issue as well as the HZ=100 suggestions at the
page above are out of date for 2.6.21 and higher kernels as the
generic timekeeping rework addressed these problems.

Please let me know if you're still seeing any such issues with NTP.

thanks
-john
