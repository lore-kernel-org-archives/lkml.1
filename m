Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbXJHT0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbXJHT0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXJHT0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:26:38 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:22209 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbXJHT0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oLEX5gANd/jpZyh3jG00iIMcFqMRXnZdsbJPnzxYBacDlZOh+wDgdD34kVW2f5VD1tKnxk4jkneCdsofwzymw2XMMO6971Ch3eQbw/JhZU50N9GIYWlrPNKPv+klM+zdkxje3eDgsWqXDka0Z9C7ztlNsRhKnAd9DAS/Qz9N2D4=
Message-ID: <7b69d1470710081226w5b6682e6q56bfa2af5ae3f017@mail.gmail.com>
Date: Mon, 8 Oct 2007 14:26:34 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: RFC: reviewer's statement of oversight
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Jonathan Corbet" <corbet@lwn.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <20071008185225.GK2902@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25555.1191864285@lwn.net>
	 <20071008173706.GA12026@uranus.ravnborg.org>
	 <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>
	 <470A708D.4080905@goop.org>
	 <20071008110614.dd671fc7.randy.dunlap@oracle.com>
	 <470A7847.8070502@s5r6.in-berlin.de>
	 <20071008185225.GK2902@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/07, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Mon, Oct 08, 2007 at 08:34:47PM +0200, Stefan Richter wrote:
...
> > So, putting a Tested-by into the changelog is only useful if the
> > necessary testing is rather simple (i.e. "fixed the bug which I was
> > always able to reproduce before") or if the tester is known to have
> > performed rigorous and sufficiently broad tests.
>
> Well, you can still include those test-method details in the body of the
> message in addition to adding the "Tested-by:".
>
> Does "Tested-by" just mean they ran some relevant test on the final
> version of the patch?  The really hard part is often the initial work
> required to find a good reproduceable test case, capture the right error
> report, or bisect to the right commit.  I think that also counts as
> "testing".  And it'd be nice to have a tag for those sorts of
> contributions, partly just as another way to ackowledge them.
---

Tested-by should, at the very least, have a description of the test
environment in the body (suggesting that the change compiled and ran
in that environment). Preferably it should also have a description of
the test or test suite run and whether that test failed on an
unpatched system.

scott
-- 
scott preece
