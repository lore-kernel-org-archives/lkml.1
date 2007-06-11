Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbXFKIZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbXFKIZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 04:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbXFKIZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 04:25:07 -0400
Received: from smtp23.orange.fr ([193.252.22.30]:56726 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbXFKIZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 04:25:04 -0400
X-ME-UUID: 20070611082502692.A90551C000B2@mwinf2342.orange.fr
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
From: Xavier Bestel <xavier.bestel@free.fr>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070608203007.3c50eb66@the-village.bc.nu>
References: <466741BD.20106@redhat.com>
	 <20070607110432.73be7960@the-village.bc.nu>
	 <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
	 <20070607151243.22caab9e.dada1@cosmosbay.com>
	 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
	 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
	 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
	 <466880A4.3090908@redhat.com>
	 <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
	 <20070608120746.GD12687@thunk.org>
	 <20070608140150.6f31672f@the-village.bc.nu>
	 <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
	 <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com>
	 <20070608203007.3c50eb66@the-village.bc.nu>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 10:24:52 +0200
Message-Id: <1181550292.11365.8.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 20:30 +0100, Alan Cox wrote:
> > To avoid exactly the kind of problem we have now in future: programs
> > relying on specific patterns.
> 
> Which you seem to think is a bad thing, yet is actually a very good thing
> because it means that crashes are repeatable and problems are debuggable
> from end user reports.

You can have both.
Look at malloc(): when you write your program you can't really guess
which address will be returned by a malloc() call, but you know that if
you launch it twice and if it has the same input, malloc()'s behavior is
repeatable so it's debuggable.

	Xav


