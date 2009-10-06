Return-Path: <linux-kernel-owner+w=401wt.eu-S932479AbZJFRdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbZJFRdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932242AbZJFRdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:33:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932186AbZJFRdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:33:39 -0400
Date: Tue, 6 Oct 2009 10:32:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: mingo@elte.hu, hohndel@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <200910061923.00723.elendil@planet.nl>
Message-ID: <alpine.LFD.2.01.0910061030380.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
 <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <200910061923.00723.elendil@planet.nl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Frans Pop wrote:
> 
> Doesn't this leave users of the git snapshot tarballs in the cold?

You can save it in .scmversion if you want to, we've supported that as a 
"export versions outside of the SCM" way since introducing 
LOCALVERSION_AUTO.

> The advantage of an -rc0 in the Makefile is that everybody gets it.

Have you missed the whole discussion about why it doesn't work?

Have you missed the point on why it is FUNDAMENTALLY WRONG to do?

You also seem to be making up more and more ludicrous examples of things 
to do. Why the f*ck cares about somebody taking a random git tree, tarring 
it up, and then building it like that?

I mean really.

		Linus
