Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZJZAfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZJZAfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 20:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZJZAfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 20:35:10 -0400
Received: from khc.piap.pl ([195.187.100.11]:36004 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbZJZAfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 20:35:09 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-next@vger.kernel.org,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: writable limits to -next
References: <4AC6339B.7000905@gmail.com>
	<20091006225751.7d5f3eec.sfr@canb.auug.org.au>
	<4AE16B0A.7020400@gmail.com>
	<20091026094741.5a1d492c.sfr@canb.auug.org.au>
Date: Mon, 26 Oct 2009 01:35:11 +0100
In-Reply-To: <20091026094741.5a1d492c.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Mon, 26 Oct 2009 09:47:41 +1100")
Message-ID: <m3eiorc7r4.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

BTW you may want to check if the current wording is correct:

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It's not ok to submit under e.g. GPL v3 only, I'd suggest "under GPL v2
and optionally other licence(s)" or something like that.

For example code under BSD-style licence (in addition to GPLv2) is
present in Linux, though I think any additional licence (the "later" as
in "GPL v2 or later", GPL v3, MS EULA etc.) is acceptable as long as it
is really additional, i.e., if one can ignore it and "use" GPLv2
exclusively.

IANAL of course.
-- 
Krzysztof Halasa
