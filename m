Return-Path: <linux-kernel-owner+w=401wt.eu-S1764147AbZDABU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764147AbZDABU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZDABUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:20:48 -0400
Received: from sous-sol.org ([216.99.217.87]:52551 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755021AbZDABUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:20:47 -0400
Date: Tue, 31 Mar 2009 18:15:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tony Battersby <tonyb@cybernetics.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [patch 25/45] SCSI: sg: fix races during device removal
Message-ID: <20090401011533.GO18394@sequoia.sous-sol.org>
References: <20090331231045.719396245@sous-sol.org> <20090331231609.657243922@sous-sol.org> <alpine.LFD.2.00.0903311628030.4130@localhost.localdomain> <1238544620.5000.5.camel@mulgrave.int.hansenpartnership.com> <alpine.LFD.2.00.0903311717330.4130@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903311717330.4130@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Wed, 1 Apr 2009, James Bottomley wrote:
> > 
> > I think we could wait a bit to see if any issues turn up in 2.6.30
> > testing.  I think it should go in eventually, though.
> 
> Sure, that sounds sane. But right now it has very little extra testing, so 
> wait with putting it into -stable at _least_ until after -rc1 release or 
> something?

I'll drop it (meaning the three).  James can you resend after they've
withstood the test of time?

thanks,
-chris
