Return-Path: <linux-kernel-owner+w=401wt.eu-S1765718AbXEVI0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765718AbXEVI0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbXEVI0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:26:36 -0400
Received: from web52610.mail.re2.yahoo.com ([206.190.48.213]:37369 "HELO
	web52610.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756436AbXEVI0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:26:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=oQ2UunmICm+O8ESIpsC3og3I78B2cEciHlkYMIOa8ujj11p6Sxry/f6C4FjG5+Q/tXneJV/oxCHzz+R0RlaHcnrRNRCyoDHKQJo4CFDWgVe8QEzXQDAN3QAbfJKonxJfPHTl2c5PTi//1WktpW/oFp532KXqQVp9vGR3ECC/6DA=;
X-YMail-OSG: rtkLgLUVM1nFDTphkT.omssbXhy5.TOsVLZ8QTII5Wr74g9sjTaJG29dAcu1d1sFQlMwCKxAUrxScIBT7V3PY_DaDUY_2Tsm05gPBw2xe7S39LMf4PUPPGkCdWdnDg--
Date: Tue, 22 May 2007 18:26:33 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070522070738.GI4705@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <404129.76498.qm@web52610.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just another data point: with the flick of CONFIG_SMP, I'm in control of the
hangs/crashes ;-).

Yup, with CONFIG_SMP=n, I'm unable to reproduce the problem. It's quite stable
actually (having completed a dozen kernel compile sessions so far).

I suspected this after seeing spinlock issues on both cores of my CPU in my
earlier report. Just a stab in the dark with some unexpected luck :-).

(Tested on http://www.kernel.org/hg/linux-2.6 changeset at 57106:3f42ad5de7cd.
That's the latest hg commit there.)

Thanks

PS: For the record everything except sysrq support is disabled in the kernel
hacking section. Also the CONFIG_SLAB_DEBUG is off. Kernel preemption is also
off, after proving it had no influence. Just to keep the test case simple.



      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

