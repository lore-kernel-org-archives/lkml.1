Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYBKP1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYBKP1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYBKP13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:27:29 -0500
Received: from mail.suse.de ([195.135.220.2]:33296 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbYBKP12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:27:28 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] [7/8] CPA: Don't flush caches on CPUs that support self-snoop
Date: Mon, 11 Feb 2008 16:27:23 +0100
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <200802111050.372086035@suse.de> <200802111612.56662.ak@suse.de> <20080211072109.029bb6c5@laptopd505.fenrus.org>
In-Reply-To: <20080211072109.029bb6c5@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111627.23751.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > That is exactly the situation in pageattr.c. You're saying the manual
> > is wrong here?
> 
> I'm saying that we are not following step 2 (marking the pages not present) 

Yes that's true. It's one of the design problems of the intent API that makes
fixing this hard unfortunately.

(intent API assumes that the caller doesn't fully own the page to change, and
if you can't control it 100% it is not possible to unmap it temporarily) 

> so 3 and 4 
> aren't all too relevant. As I said before I've asked internally about this and got
> mixed answers so I'm still chasing it down.

Ok.

-Andi


