Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbZG0GTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbZG0GTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 02:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZG0GTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 02:19:22 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:29265 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZG0GTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 02:19:21 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [Bug #13730] hitting lockdep limits...
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>
In-Reply-To: <3zAHs5O6maO.A.c9D.3HObKB@chimera>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.c9D.3HObKB@chimera>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 08:21:40 +0200
Message-Id: <1248675700.6987.1416.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-26 at 22:28 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13730
> Subject		: hitting lockdep limits...
> Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
> Date		: 2009-07-05 18:19 (22 days old)
> References	: http://marc.info/?l=linux-kernel&m=124681799023782&w=4
> 


Is this still a problem after?

commit b0a5b83ee0fce9dbf8ff5fe1f8c9ae7dfafe458c
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Jun 16 16:11:14 2009 +0200

    dma-debug: Put all hash-chain locks into the same lock class


