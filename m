Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZHKWo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZHKWo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 18:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZHKWo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 18:44:28 -0400
Received: from neskaya.eckenfels.net ([195.49.138.57]:51088 "EHLO
	neskaya.eckenfels.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbZHKWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 18:44:27 -0400
X-Greylist: delayed 2345 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Aug 2009 18:44:27 EDT
Date: Wed, 12 Aug 2009 00:00:15 +0200 (CEST)
Message-Id: <200908112200.n7BM0FSK070363@neskaya.eckenfels.net>
From: Bernd Eckenfels <bernd-09@eckenfels.net>
To: linux-kernel@vger.kernel.org
Subject: Re: What happened to data=guarded?
In-Reply-To: <20090810164205.GC1505@ucw.cz>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.8.3-20070201 ("Scotasay") (UNIX) (FreeBSD/7.2-PRERELEASE (i386))
X-Spam-Score: -0.6 (/)
X-Spam-Report: Spam detection software, running on the system "neskaya.eckenfels.net", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	The administrator of that system for details.
	Content preview:  In article <20090810164205.GC1505@ucw.cz> you wrote: >> What
	sort of files were you losing? I don't know if we can improve >> the implied
	flush hueristics, but we should at least try to see if we >> do something
	about it. > > IIRC... the flush heuristics invoke async flush, so you can
	still lose > data if you are unlucky, no? [...] 
	Content analysis details:   (-0.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.4 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	0.6 J_CHICKENPOX_47        BODY: 4alpha-pock-7alpha
	0.2 AWL                    AWL: From: address is in the auto white-list
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: ecki@neskaya.eckenfels.net
X-SA-Exim-Scanned: No (on neskaya.eckenfels.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20090810164205.GC1505@ucw.cz> you wrote:
>> What sort of files were you losing?  I don't know if we can improve
>> the implied flush hueristics, but we should at least try to see if we
>> do something about it.
> 
> IIRC... the flush heuristics invoke async flush, so you can still lose
> data if you are unlucky, no?

BTW: one good heuristic would be to flush() files on close async but if the
file is renamed fush it sync before the rename.  The typical close temp file
and rename it would work without a fdatasync().

Gruss
Bernd
