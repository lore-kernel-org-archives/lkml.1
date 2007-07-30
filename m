Return-Path: <linux-kernel-owner+w=401wt.eu-S968350AbXG3UCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968350AbXG3UCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967394AbXG3UCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:02:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45624 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967257AbXG3UCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:02:18 -0400
Date: Tue, 31 Jul 2007 01:44:37 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "John W. Linville" <linville@tuxdriver.com>
cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] Use mutex instead of semaphore in the Host AP
 driver
In-Reply-To: <20070730145005.GB6586@tuxdriver.com>
Message-ID: <alpine.LFD.0.999.0707310142190.17287@enigma.security.iitk.ac.in>
References: <20070729212909.GC3432@traven> <20070729213434.GD3432@traven>
 <200707300006.42397.mb@bu3sch.de> <alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in>
 <alpine.LFD.0.999.0707300904360.10861@enigma.security.iitk.ac.in>
 <20070730054004.GI3432@traven> <alpine.LFD.0.999.0707301247100.12730@enigma.security.iitk.ac.in>
 <20070730145005.GB6586@tuxdriver.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, John W. Linville wrote:

> On Mon, Jul 30, 2007 at 12:50:31PM +0530, Satyam Sharma wrote:
> > On Mon, 30 Jul 2007, Matthias Kaehlcke wrote:
> > 
> > > [...]
> > > The Host AP driver uses a semaphore as mutex. Use the mutex API
> > > instead of the (binary) semaphore.
> > > 
> > > Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> > 
> > Reviewed-by: Satyam Sharma <satyam@infradead.org>
> 
> Is that the same as Acked-by?  Or do you disagree with the patch?
> 
> Just checkin'...

Well, I'm not the maintainer, so didn't think correct to give an
"Acked-by". "Reviewed-by" generally means I read the patch, and think
it is correct. Probably could save time for others ...


Satyam
