Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbXJHSxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbXJHSxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbXJHSxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:53:42 -0400
Received: from mail.fieldses.org ([66.93.2.214]:54615 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424AbXJHSxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:53:41 -0400
Date: Mon, 8 Oct 2007 14:52:25 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
Message-ID: <20071008185225.GK2902@fieldses.org>
References: <25555.1191864285@lwn.net> <20071008173706.GA12026@uranus.ravnborg.org> <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr> <470A708D.4080905@goop.org> <20071008110614.dd671fc7.randy.dunlap@oracle.com> <470A7847.8070502@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470A7847.8070502@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 08:34:47PM +0200, Stefan Richter wrote:
> Randy Dunlap wrote:
> > On Mon, 08 Oct 2007 11:01:49 -0700 Jeremy Fitzhardinge wrote:
> >> Tested-by is more valuable than acked-by, because its empirical. 
> >> Acked-by generally means "I don't generally object to the idea of the
> >> patch, but may not have read beyond the changelog".  Tested-by implies
> >> "I did something that exercised the patch, and it didn't explode" -
> >> that's on par with an actual review (ideally all patches would be both
> >> tested and reviewed).
> > 
> > but Tested-by: doesn't have to involve any "actually looking at/reading
> > the patch."  Right?
> > 
> > IOW, the patch could be ugly as sin but it works...
> 
> Tested-by translated into German and back into English:  "Works for me,
> test methods not specified."
> 
> So, putting a Tested-by into the changelog is only useful if the
> necessary testing is rather simple (i.e. "fixed the bug which I was
> always able to reproduce before") or if the tester is known to have
> performed rigorous and sufficiently broad tests.

Well, you can still include those test-method details in the body of the
message in addition to adding the "Tested-by:".

Does "Tested-by" just mean they ran some relevant test on the final
version of the patch?  The really hard part is often the initial work
required to find a good reproduceable test case, capture the right error
report, or bisect to the right commit.  I think that also counts as
"testing".  And it'd be nice to have a tag for those sorts of
contributions, partly just as another way to ackowledge them.

--b.
