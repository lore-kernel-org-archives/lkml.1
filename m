Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZCNXpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZCNXpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 19:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZCNXpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 19:45:09 -0400
Received: from gw.goop.org ([64.81.55.164]:56883 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZCNXpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 19:45:08 -0400
Message-ID: <49BC4181.70603@goop.org>
Date: Sat, 14 Mar 2009 16:45:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: akataria@vmware.com, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: VMI broken on tip/master...
References: <1236966968.14680.15.camel@alok-dev1> <1237072800.8939.813.camel@laptop>
In-Reply-To: <1237072800.8939.813.camel@laptop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> So what was supposed to be a simple op, now gets expanded into god knows
> what, and might lead to tracer recursion or something.

I don't think that's relevent in this case; Alok's report is not that 
this code crashes, but that this changeset causes a crash somewhere in 
the VMI/paravirt patching code.  Very odd.

    J
