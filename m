Return-Path: <linux-kernel-owner+w=401wt.eu-S1764173AbXJTFpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764173AbXJTFpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 01:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbXJTFou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 01:44:50 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:37425 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbXJTFot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 01:44:49 -0400
X-IronPort-AV: E=Sophos;i="4.21,302,1188802800"; 
   d="scan'208";a="537724439"
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2.6.23-git] toplevel Makefile/depmod bugfix
X-Message-Flag: Warning: May contain useful information
References: <20071020044224.DD48423A6FC@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20071020053642.GA4535@uranus.ravnborg.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 19 Oct 2007 22:44:46 -0700
In-Reply-To: <20071020053642.GA4535@uranus.ravnborg.org> (Sam Ravnborg's message of "Sat, 20 Oct 2007 07:36:42 +0200")
Message-ID: <ada6412bar5.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Oct 2007 05:44:46.0454 (UTC) FILETIME=[52656160:01C812DC]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Accoding to man bash "==" is used to test for equality and "=" is used for assignmnet.
 > I assume the above is a dash syntax error (dash is default on ubuntu IIRC).

My bash man page says the following under "CONDITIONAL EXPRESSIONS":

       string1 == string2
              True if the strings are equal.  = may be used in place
              of == for strict POSIX compliance.

This is bash 3.1 as packaged by Debian.

So I think "=" is the correct thing to use for compatibility with dash
or other non-bash shells, since as far as I know, there are no
situations where a comparison with "=" will fail but "==" will succed.
(ie "=" is strictly more compatible).

 - R.
