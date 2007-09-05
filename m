Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbXIEKDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbXIEKDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 06:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbXIEKC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 06:02:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50376 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbXIEKC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 06:02:58 -0400
Date: Wed, 5 Sep 2007 12:02:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: building a specific in-tree module is currently a bit broken
In-Reply-To: <Pine.LNX.4.64.0709050536410.31804@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0709051202200.5419@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709050509150.27539@localhost.localdomain>
 <6bffcb0e0709050237m7d948782iffec36253c6fccb2@mail.gmail.com>
 <Pine.LNX.4.64.0709051142080.5419@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709050536410.31804@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 5 2007 05:42, Robert P. J. Day wrote:
>that doesn't solve the problem.  i should have mentioned that i
>already (unnecessarily, i suggest) ran "make modules_prepare", but the
>problem persists.
>
>the issue seems to be that running that last make command to build the
>module visor.ko doesn't somehow signal the Makefile that this is a
>*module* build, and therefore no module-related initialization is
>done, such as creating that directory or setting the Makefile variable
>MODVERDIR, etc, etc.

ah... make M=drivers/foo/bar/
it builds the whole directory, but at least it builds it.


>
>once you've build at least one module successfully, then the directory
>.tmp_versions exists so future module builds will work fine.  it's
>only when you do a clean, *immediately* followed by trying to do an
>in-tree module build, that this is going to bite you.

	Jan
-- 
