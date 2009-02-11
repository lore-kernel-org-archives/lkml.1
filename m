Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbZBKUMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbZBKUMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 15:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbZBKUMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 15:12:10 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34526 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbZBKUMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 15:12:09 -0500
Date: Wed, 11 Feb 2009 18:34:51 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Doug Bazarnic <kernel@bazarnic.net>
cc: linux-kernel@vger.kernel.org, Sami Farin <safari-kernel@safari.iki.fi>,
       Rafael Wysocki <rjw@sisk.pl>
Subject: RE: 2.6.28.4 regression: mmap fails if mlockall used
In-Reply-To: <033401c98c15$c868c100$593a4300$@net>
Message-ID: <Pine.LNX.4.64.0902111827020.6392@blonde.anvils>
References: <20090208105222.hj7zhcyxyqfjeobt@m.safari.iki.fi>
 <Pine.LNX.4.64.0902081802480.14394@blonde.anvils>
 <20090208192340.mydonrnzi3os734u@m.safari.iki.fi>
 <Pine.LNX.4.64.0902082025470.14955@blonde.anvils> <033401c98c15$c868c100$593a4300$@net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009, Doug Bazarnic wrote:
> I can confirm the mlock.c patch works on 2.6.28.4.  2.6.28.3 works fine.
> This issue happens on both Centos 5.2 x86_64 and RHEL 5.3 x86_64.
> 
> Without the mlock.c patch, ntpd fails to start on 2.6.28.4:
> Feb 10 22:03:19 testbox ntpd[4030]: kernel time sync status 0040
> Feb 10 22:03:19 testbox ntpd[4030]: getaddrinfo: "127.0.0.1" invalid host
> address, ignored
> Feb 10 22:03:19 testbox ntpd[4030]: getaddrinfo: "::1" invalid host address,
> ignored
> Feb 10 22:03:19 testbox ntpd[4030]: getaddrinfo: "127.127.1.0" invalid host
> address, ignored
> Feb 10 22:03:19 testbox ntpd[4030]: Cannot find user `ntp'
> Feb 10 22:03:21 testbox ntpd_initres[4034]: parent died before we finished,
> exiting
> 
> Fyi.. gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)
> 
> Thanks to Sami for mentioning ntpd failures, as I was going nuts trying to
> figure out why my ntpd.conf file wasn't working anymore.  
> 
> Thanks for the patch as well.

Thanks a lot for testing and confirming:
you should find the fix is in 2.6.28.5, due out maybe tomorrow.

Rafael, you did already close Bug #12669 - now please cancel my
suggestion that it remain open until the fix has been confirmed ;)

Hugh
