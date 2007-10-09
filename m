Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbXJICJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbXJICJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 22:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXJICJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 22:09:30 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:52741 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbXJICJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 22:09:29 -0400
Date: Mon, 8 Oct 2007 22:07:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Scott Preece <sepreece@gmail.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
Message-ID: <20071009020750.GB4504@goodmis.org>
References: <25555.1191864285@lwn.net> <20071008185225.GK2902@fieldses.org> <7b69d1470710081226w5b6682e6q56bfa2af5ae3f017@mail.gmail.com> <200710082216.28227.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710082216.28227.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 10:16:26PM +0200, Rafael J. Wysocki wrote:
> 
> Tested-by: is sort of trivial for a fix patch, for example, if a bug reporter
> confirms that the proposed patch actually fixes the issue.  IMHO it wouldn't
> be practical to complicate that.
>

I see two types of Tested-by.

1) As you stated, a fixed to a problem that the reporter has seen. So
that someone could state a "fixes issue" in the change log and that
would simple mean that the tester has seen a problem, and the attached
patch fixes it.

2) Someone has a testsuite to the area that the change affects. So if
someone has developed a networking test suite and a patch changes some
networking logic, the Tested-by could be that the tester actually ran
specific tests.  This should require a more detail explaination of what
was done. Or the very least, a pointer to a web page of the tests that
were run.

So for the user that sees an issue, then gets a patch, perhaps all they
need to do is add a "fixed problem" or "works now" in the change log to
denote that the patch has actually (or seems to) fix the problem that
they previously seen. This shouldn't be too hard.

But for those that run test suites, they should be smart enough to put
in more documentation into the change log to state how it was tested.

Perhaps we need to add yet another signed off.

"Verified-by", which could be for the user that saw an issue and the
patch now fixes it. That user could just add the "Verified-by" to the
patch to acknowledge (and record) that the patch did fix the issue.

The "Tested-by" can be used for patches that are run through a test
suite.

Just a thought.

-- Steve

