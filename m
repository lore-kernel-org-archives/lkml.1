Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZLUQDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZLUQDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZLUQDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:03:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbZLUQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:03:41 -0500
Date: Mon, 21 Dec 2009 08:03:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dominik Brodowski <linux@dominikbrodowski.net>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resources: fix call to alignf() in allocate_resource()
In-Reply-To: <20091221084031.GB1648@isilmar.linta.de>
Message-ID: <alpine.LFD.2.00.0912210801260.21722@localhost.localdomain>
References: <20091220095001.GA6029@comet.dominikbrodowski.net> <alpine.LFD.2.00.0912201026570.3712@localhost.localdomain> <20091221084031.GB1648@isilmar.linta.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Dec 2009, Dominik Brodowski wrote:
> 
> At least the PCMCIA "align" function makes excessive use of the "size"
> parameter, so we'd still need this.

I noticed that it also uses 'res->end' (in the meaning "skip this one as 
unacceptable").

> What about taking my patch for 2.6.33, and deferring the change to the
> calling convention to the 2.6.34 merge window? (I'll try to cook something
> up and get it into linux-next during the next few weeks).

Sounds like a plan,

		Linus
