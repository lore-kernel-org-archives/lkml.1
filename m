Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbXEJUAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbXEJUAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbXEJUAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:00:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031AbXEJUAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:00:43 -0400
Date: Thu, 10 May 2007 22:00:33 +0200
From: Tomas Janousek <tjanouse@redhat.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
Subject: Re: [PATCH] Introduce boot based time
Message-ID: <20070510200033.GA31048@redhat.com>
References: <1178302732.5929.23.camel@localhost.localdomain> <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz> <200705102149.01714.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705102149.01714.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, May 10, 2007 at 09:48:59PM +0200, Ingo Oeser wrote:
> > +static unsigned long total_sleep_time;
> 
> Could you make that a ktime_t (or struct ktime)?
> There are machines, which sleep more than they are awake. 
> Just imagine a surveillance camera triggered by door entrance.
> 
> Yes, these things might run Linux (e.g. on "cris" architecture).
> 
> Or your VCR.
> Yes, these devices might sleep more than they are awake, 
> if you are not a TV junkie :-)

The value is in seconds. It can hold up to 136 years of sleep. I'd rather
spend the money on beer than on a VCR that I'm gonna suspend for 137 years :)

(or do we have a 16-bit long anywhere?)

Regards,
-- 
TJ. (Brno, CZ), BaseOS, Red Hat
