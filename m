Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZDAAfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZDAAfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZDAAfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:35:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbZDAAfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:35:30 -0400
Date: Tue, 31 Mar 2009 17:18:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
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
In-Reply-To: <1238544620.5000.5.camel@mulgrave.int.hansenpartnership.com>
Message-ID: <alpine.LFD.2.00.0903311717330.4130@localhost.localdomain>
References: <20090331231045.719396245@sous-sol.org>  <20090331231609.657243922@sous-sol.org>  <alpine.LFD.2.00.0903311628030.4130@localhost.localdomain> <1238544620.5000.5.camel@mulgrave.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Apr 2009, James Bottomley wrote:
> 
> I think we could wait a bit to see if any issues turn up in 2.6.30
> testing.  I think it should go in eventually, though.

Sure, that sounds sane. But right now it has very little extra testing, so 
wait with putting it into -stable at _least_ until after -rc1 release or 
something?

		Linus
