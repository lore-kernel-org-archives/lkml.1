Return-Path: <linux-kernel-owner+w=401wt.eu-S937164AbXHGWN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937164AbXHGWN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937610AbXHGWGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:06:50 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33753 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938184AbXHGWGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:06:49 -0400
Date: Wed, 8 Aug 2007 00:06:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chris Friesen <cfriesen@nortel.com>
cc: Chris Snook <csnook@redhat.com>, Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
In-Reply-To: <46B8E64E.7010708@nortel.com>
Message-ID: <Pine.LNX.4.64.0708080005260.26397@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain>
 <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com>
 <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com>
 <46B8DDF3.7050008@nortel.com> <46B8E1D3.8050501@redhat.com>
 <46B8E64E.7010708@nortel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7 2007 15:38, Chris Friesen wrote:
> Even now, powerpc (as an example) defines atomic_t as:
>
> typedef struct { volatile int counter; } atomic_t
>
>
> That volatile is there precisely to force the compiler to dereference it every
> single time.

Actually, the dereference will be done once (or more often if registers
are short or the compiler does not feel like keeping it around),
and the read from memory will be done on every iteration ;-)


	Jan
-- 
