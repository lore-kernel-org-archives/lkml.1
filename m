Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXHTFI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXHTFI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 01:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXHTFIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 01:08:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55632 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbXHTFIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 01:08:20 -0400
Subject: Re: Non atomic unaligned writes
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20070820005522.GA5069@Krystal>
References: <200707191105.44056.ak@suse.de> <p73d4yow0ys.fsf@bingen.suse.de>
	 <469FC9D4.5070604@goop.org> <200707192246.58047.ak@suse.de>
	 <20070820005522.GA5069@Krystal>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 19 Aug 2007 22:03:13 -0700
Message-Id: <1187586193.5408.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 (2.11.90-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Are misaligned/cross-cache-line updates atomic?
> > 
> > In theory yes, in practice there can be errata of course. 

Afaik the theory is "Platform specific; most x86 will be in practice";
it's up to the system vendor and chipset vendor. 

The practice is "mixed ball, slow as h*ck anyway, just never ever do it"


