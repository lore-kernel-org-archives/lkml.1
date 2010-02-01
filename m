Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0BAQBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:01:05 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:60592 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab0BAQBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:01:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lx8QgcB8/52m3irzP9RxPQ/LGEhUQJB7BtcsiJdOrxC0uXFXyxJQtU3YpLvR9tucgX
         HsuO0Cy/Pce5CnOM+6wKhsfokQEu14jkQ5W7uv98Uxzozdc8CEb7Bfgp37mfQiTyO93J
         BI7sdnr5b/j6uM95s78wLALn2E3694ea2Hbgg=
MIME-Version: 1.0
In-Reply-To: <1265021838.5234.21.camel@subratamodak.linux.ibm.com>
References: <1265021838.5234.21.camel@subratamodak.linux.ibm.com>
Date: Mon, 1 Feb 2010 08:01:01 -0800
Message-ID: <364299f41002010801w178b2d75yc4840adcf8e0f64c@mail.gmail.com>
Subject: Re: [ANNOUNCE] The Linux Test Project has been released for JANUARY 
	2010
From: Garrett Cooper <yanegomi@gmail.com>
To: subrata@linux.vnet.ibm.com
Cc: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 2:57 AM, Subrata Modak
<subrata@linux.vnet.ibm.com> wrote:
> Hi,
>
> The Linux Test Project test suite has been released for the month of
> JANUARY 2010. Please see ltp/INSTALL file carefully, as, there has
> been multiple changes for building/installing the test suite after the
> recent changes in Makefile infrastructure.
>
> The latest version of the test-suite contains 3000+ tests for the Linux
> OS and can be found at:
> http://ltp.sourceforge.net/,
> Latest happenings in LTP can also be found at:
> http://ltp.sourceforge.net/wiki/,
> http://ltp.sourceforge.net/wikiArchives.php, and,
> IRC: irc.freenode.org #ltp.
>
> Our web site also contains other information such as:
> - A Linux test tools matrix
> - Technical papers
> - How To's on Linux testing
> - Code coverage analysis tool.
>
> We would encourage the community to post results to
> ltp-results@lists.sf.net,
> patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
> http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382 (for
> New Bug(s)),
> http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382 (for
> New Patch(s)),
> http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382 (for
> New Feature Request(s))
>
> **Note: Some pending patches will be checked in for next monthś release.

    For those who have been holding off on upgrading since the Make
infrastructure revision was done back in October, I highly suggest
that they evaluate this release as a several issues have been
resolved, i.e. selinux-testsuite being fixed to meet the make
infrastructure changes (there's just a minor issue that's been
reported on RHEL 5.4 with the policy files -- Stephen should be
working with Mitani-san to resolve the issue), and a few autoconf
related items have been resolved. Furthermore, make 3.80 support has
been integrated into the project so folks can once again use make 3.80
when building LTP.
All the best,
-Garrett
