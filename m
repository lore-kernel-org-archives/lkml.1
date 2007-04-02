Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbXDBP24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbXDBP24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXDBP2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:28:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55124 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXDBP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:28:55 -0400
Date: Mon, 2 Apr 2007 17:28:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tasos Parisinos <t.parisinos@sciensis.com>
Cc: Andi Kleen <andi@firstfloor.org>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, indan@nul.nu
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Message-ID: <20070402152852.GA30501@one.firstfloor.org>
References: <4610D25F.7080005@ceid.upatras.gr> <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com> <20070402132820.GA28983@one.firstfloor.org> <46111D03.5020905@sciensis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46111D03.5020905@sciensis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Please read the thread i gave you for some details for things you ask

I don't see much useful information in the thread. It's the
same high level handwaving from you there as in this.

> Have in thought that we mostly talk here about embedded devices
> that run Linux in a very restricted environment where only specific

Ok so they don't X servers? But did you audit all the ioctls of
all their drivers that they don't allow memory access? And plugged
the other interfaces like io port access etc.? 

And besides where is this code for review? There's a pretty firm policy
to not integrate any code without users because that guarantees
bitrot.

-Andi
