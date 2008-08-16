Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbYHPTGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbYHPTGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYHPTGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:06:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbYHPTGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:06:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: s2disk: system powers up again after power off
Date: Sat, 16 Aug 2008 21:09:43 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Avuton Olrich <avuton@gmail.com>, linux-kernel@vger.kernel.org
References: <20080715124733.GA4111@deprecation.cyrius.com> <200807161737.12370.rjw@sisk.pl> <20080816134809.GC2758@deprecation.cyrius.com>
In-Reply-To: <20080816134809.GC2758@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808162109.44295.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 16 of August 2008, Martin Michlmayr wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> [2008-07-16 17:37]:
> > > > Please try to put "shutdown method = shutdown" into the s2disk's configuration
> > > > file and see what happens in that case.
> > > Yep, this work.
> > 
> > This is a workaround, though.
> > 
> > Can you check if the problem is present in linux-next, please?
> 
> I finally got a chance to test 2.6.27-rc2 and confirm that my laptop
> correctly powers off with "shutdown method = platform now".
> 
> Do you have any idea which patch might have fixed this?  It would be
> nice to include it in Debian's 2.6.26 kernel.

There was a series of commits ending with commit
337001b6c42938f49a880b1b8306c3ed771a7e61 ("PCI: Simplify PCI device PM code").

Unfortunately I don't think it's practicable to backport all of those patches.

Thanks,
Rafael

