Return-Path: <linux-kernel-owner+w=401wt.eu-S940533AbXHIO1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940533AbXHIO1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965273AbXHIO12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:27:28 -0400
Received: from ns2.suse.de ([195.135.220.15]:45486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936637AbXHIO11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:27:27 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
Date: Thu, 9 Aug 2007 16:26:57 +0200
User-Agent: KMail/1.9.6
Cc: Glauber de Oliveira Costa <glommer@gmail.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <5d6222a80708090007h3d185ecdm3ea8fa0b5ee96050@mail.gmail.com> <46BABE72.90107@goop.org>
In-Reply-To: <46BABE72.90107@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091626.57736.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hm.  So x86-64 doesn't make 64-bit pointers be 64-bit aligned?

The ABI does of course, although the penalty of not doing it on current
CPUs is only minor.

-Andi
