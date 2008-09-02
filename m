Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYIBQDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYIBQDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYIBQDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:03:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:37733 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYIBQDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:03:14 -0400
Date: Tue, 2 Sep 2008 09:03:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 13/13] hrtimer: make select() and poll() use the hrtimer
 range feature
Message-ID: <20080902090312.7fb3c7b6@infradead.org>
In-Reply-To: <1220343740.8609.21.camel@twins>
References: <20080901160343.75a89ec9@infradead.org>
	<20080901161459.0990a16b@infradead.org>
	<1220343740.8609.21.camel@twins>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008 10:22:20 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> Why not use a simple logarithmic decay to drive this estimate?

or just take a 0.1% of the time ;)

Linus wrote the original, who am I to argue? 
(and arguably, it doesn't really matter much, the current code is nice
and simple enough)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
