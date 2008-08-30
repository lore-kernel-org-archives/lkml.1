Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYH3Vkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYH3Vkd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759815AbYH3VdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:33:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46354
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757836AbYH3VdC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:33:02 -0400
Date: Sat, 30 Aug 2008 14:32:56 -0700 (PDT)
Message-Id: <20080830.143256.62760515.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, bunk@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, protasnb@gmail.com,
       kernel-testers@vger.kernel.org
Subject: Re: 2.6.27-rc5-git2: Reported regressions from 2.6.26
From: David Miller <davem@davemloft.net>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sat, 30 Aug 2008 21:46:30 +0200 (CEST)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11409
> Subject		: build issue #564 for v2.6.27-rc4 : undefined reference to `NS8390p_init'
> Submitter	: Toralf Förster <toralf.foerster@gmx.de>
> Date		: 2008-08-22 8:33 (9 days old)
> References	: http://marc.info/?l=linux-kernel&m=121939410214677&w=4
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Patch		: http://marc.info/?l=linux-kernel&m=121943097320451&w=4

Should be fixed by:

commit d3d7b53d1ae46534cd73e1073a5c29e3b61a0552
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Fri Aug 22 19:24:15 2008 +0100

    [netdrvr] fix build issue: undefined reference to `NS8390p_init'
    
    Signed-off-by: Alan 'pass the paper bags' Cox <alan@redhat.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

