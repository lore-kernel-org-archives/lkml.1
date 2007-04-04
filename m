Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbXDDXkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbXDDXkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXDDXkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:40:14 -0400
Received: from gw.goop.org ([64.81.55.164]:32906 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbXDDXkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:40:12 -0400
Message-ID: <46143741.3020408@goop.org>
Date: Wed, 04 Apr 2007 16:39:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack	pagetable
 entries
References: <20070402055652.610711908@goop.org>	 <200704041347.42822.ak@suse.de> <4613C828.2030604@goop.org>	 <200704041756.35016.ak@suse.de> <1175727549.12230.583.camel@localhost.localdomain>
In-Reply-To: <1175727549.12230.583.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> You'll still have the damage inflicted on gcc's optimizer, though.

Well, I could remove the clobbers for PVOP_CALL[0-2] and add the
appropriate push/pops, and put similar push/pop wrappers around all the
called functions.  But it doesn't make it any prettier.

    J
