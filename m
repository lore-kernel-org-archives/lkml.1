Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbXIZQwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbXIZQwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbXIZQvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:51:53 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37211 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbXIZQvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:51:52 -0400
Date: Wed, 26 Sep 2007 12:51:05 -0400
Message-Id: <200709261651.l8QGp5bA031636@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 10/25] Unionfs: add un/likely conditionals on copyup ops 
In-reply-to: Your message of "Wed, 26 Sep 2007 18:47:56 +0200."
             <Pine.LNX.4.64.0709261845110.7066@fbirervta.pbzchgretzou.qr> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0709261845110.7066@fbirervta.pbzchgretzou.qr>, Jan Engelhardt writes:
> 
> On Sep 26 2007 11:43, Erez Zadok wrote:
> >
> >*That's* the information I was looking for, Kyle: what's the estimated
> >probability I should be using as my guideline.  I used 95% (20/1 ratio), and
> 
> ;-)
> 
> 19:1 <=> 95:5 <=> 95% <=> ratio=0.95  != 20.0 (=20/1)
> 
> >you're telling me I should use 99% (100/1 ratio).  The difference between
> 
> 99:1 <=> 99% <=> ratio=0.99  != 100.0 (=100/1)
> 
> >the number of cycles saved/added is very compelling.  Given that I certainly
> >agree with you that I'm using un/likely too much.  I'll re-evaluate and
> >update my patch series then.

Yeah, close enough. :-)

The important issue is that I'm probably using about five times too many
un/likely wrappers.

Erez.
