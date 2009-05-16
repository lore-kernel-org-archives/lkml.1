Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbZEPXN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbZEPXN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZEPXNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:13:17 -0400
Received: from vena.lwn.net ([206.168.112.25]:41132 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbZEPXNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:13:17 -0400
Date: Sat, 16 May 2009 17:13:16 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.30-rc kills my box hard - and lockdep chains
Message-ID: <20090516171316.3e68d4f9@bike.lwn.net>
In-Reply-To: <20090516160345.5bec42d7.akpm@linux-foundation.org>
References: <20090514094951.36fd7333@bike.lwn.net>
	<1242365555.26820.51.camel@twins>
	<20090516160345.5bec42d7.akpm@linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009 16:03:45 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Jon said that doubling MAX_LOCKDEP_CHAINS didn't help.  How much did
> the above patch increase things by?

I doubled MAX_LOCKDEP_ENTRIES, but hadn't yet gotten around to trying
MAX_LOCKDEP_CHAINS.  It felt like I was going into territory where
nobody else was complaining, so it seemed like maybe trying to paper
over something else.  I've not had a chance to go back and try with
both parameters increased, will do.

jon
