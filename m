Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZBKV4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZBKV4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZBKV4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:56:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57281 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbZBKV4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:56:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.28.4 regression: mmap fails if mlockall used
Date: Wed, 11 Feb 2009 22:56:14 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-tst; KDE/4.2.0; x86_64; ; )
Cc: Doug Bazarnic <kernel@bazarnic.net>, linux-kernel@vger.kernel.org,
       Sami Farin <safari-kernel@safari.iki.fi>
References: <20090208105222.hj7zhcyxyqfjeobt@m.safari.iki.fi> <033401c98c15$c868c100$593a4300$@net> <Pine.LNX.4.64.0902111827020.6392@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902111827020.6392@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902112256.14988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 February 2009, Hugh Dickins wrote:
> On Tue, 10 Feb 2009, Doug Bazarnic wrote:
> > I can confirm the mlock.c patch works on 2.6.28.4.  2.6.28.3 works fine.
> > This issue happens on both Centos 5.2 x86_64 and RHEL 5.3 x86_64.
> > 
> > Without the mlock.c patch, ntpd fails to start on 2.6.28.4:
> > Feb 10 22:03:19 testbox ntpd[4030]: kernel time sync status 0040
> > Feb 10 22:03:19 testbox ntpd[4030]: getaddrinfo: "127.0.0.1" invalid host
> > address, ignored
> > Feb 10 22:03:19 testbox ntpd[4030]: getaddrinfo: "::1" invalid host address,
> > ignored
> > Feb 10 22:03:19 testbox ntpd[4030]: getaddrinfo: "127.127.1.0" invalid host
> > address, ignored
> > Feb 10 22:03:19 testbox ntpd[4030]: Cannot find user `ntp'
> > Feb 10 22:03:21 testbox ntpd_initres[4034]: parent died before we finished,
> > exiting
> > 
> > Fyi.. gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)
> > 
> > Thanks to Sami for mentioning ntpd failures, as I was going nuts trying to
> > figure out why my ntpd.conf file wasn't working anymore.  
> > 
> > Thanks for the patch as well.
> 
> Thanks a lot for testing and confirming:
> you should find the fix is in 2.6.28.5, due out maybe tomorrow.
> 
> Rafael, you did already close Bug #12669 - now please cancel my
> suggestion that it remain open until the fix has been confirmed ;)

Sure, it's going to stay closed. ;-)

Rafael
