Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835Ab0ATSEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0ATSEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418Ab0ATSE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:04:29 -0500
Received: from khc.piap.pl ([195.187.100.11]:44560 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab0ATSE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:04:28 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Ramagudi Naziir <naziirr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how do YOU hack the linux kernel ?
References: <dfb262381001190452k3bad790ax14bbdbe92210b2d3@mail.gmail.com>
Date: Wed, 20 Jan 2010 19:04:22 +0100
In-Reply-To: <dfb262381001190452k3bad790ax14bbdbe92210b2d3@mail.gmail.com>
	(Ramagudi Naziir's message of "Tue, 19 Jan 2010 14:52:57 +0200")
Message-ID: <m3my08tzyx.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramagudi Naziir <naziirr@gmail.com> writes:

> do you use vim ?

Sure, for small changes. And emacs.

> If so, how do you open files you want to read/edit ?
> Assuming you don't remember their exact name/location, you'd need to
> use something like 'find . -iname '*pattern*'. which is slow.

Not very slow, if the tree is already in cache. You need only ca. 1 GB
of RAM for this. I never use ".", I use "*" instead as it ignores .git
directory:

$ time find * -iname \*pattern\*
real    0m0.051s

$ time grep "The pattern" * -r
(results)
real    0m0.330s

(grep -i is much slower).

Other tools? Git, gitk and WWW browser :-)
-- 
Krzysztof Halasa
