Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbYH3Vlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbYH3Vlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760550AbYH3ViS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:38:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760541AbYH3ViQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:38:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: 2.6.27-rc5-git2: Reported regressions from 2.6.26
Date: Sat, 30 Aug 2008 23:42:25 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, bunk@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, protasnb@gmail.com,
       kernel-testers@vger.kernel.org
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <20080830.143256.62760515.davem@davemloft.net>
In-Reply-To: <20080830.143256.62760515.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808302342.27062.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 30 of August 2008, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sat, 30 Aug 2008 21:46:30 +0200 (CEST)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11409
> > Subject		: build issue #564 for v2.6.27-rc4 : undefined reference to `NS8390p_init'
> > Submitter	: Toralf Förster <toralf.foerster@gmx.de>
> > Date		: 2008-08-22 8:33 (9 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121939410214677&w=4
> > Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Patch		: http://marc.info/?l=linux-kernel&m=121943097320451&w=4
> 
> Should be fixed by:
> 
> commit d3d7b53d1ae46534cd73e1073a5c29e3b61a0552
> Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date:   Fri Aug 22 19:24:15 2008 +0100
> 
>     [netdrvr] fix build issue: undefined reference to `NS8390p_init'
>     
>     Signed-off-by: Alan 'pass the paper bags' Cox <alan@redhat.com>
>     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Thanks, closed.

Rafael
