Return-Path: <linux-kernel-owner+w=401wt.eu-S1764393AbZCaXu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764393AbZCaXu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761524AbZCaXuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:50:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758458AbZCaXuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:50:03 -0400
Date: Tue, 31 Mar 2009 16:31:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Wright <chrisw@sous-sol.org>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
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
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 25/45] SCSI: sg: fix races during device removal
In-Reply-To: <20090331231609.657243922@sous-sol.org>
Message-ID: <alpine.LFD.2.00.0903311628030.4130@localhost.localdomain>
References: <20090331231045.719396245@sous-sol.org> <20090331231609.657243922@sous-sol.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Mar 2009, Chris Wright wrote:
> 
> From: Tony Battersby <tonyb@cybernetics.com>
> 
> upstream commit: c6517b7942fad663cc1cf3235cbe4207cf769332
> 
> sg has the following problems related to device removal:

Hmm. Is this a new problem to 2.6.29?

The patch is pretty big (certainly _way_ over the official -stable limit), 
and I don't know how critical or new this bug was. I doubt it has gotten 
much testing in the development branch either, yet.

So please convince me that this shouldn't wait a bit, or at least point me 
to the problem reports to convince me that the size limit should be 
ignored.

		Linus
