Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbXDOUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbXDOUKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXDOUKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:10:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4346 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753643AbXDOUKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:10:38 -0400
Date: Sun, 15 Apr 2007 20:10:24 +0000
From: Pavel Machek <pavel@ucw.cz>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Maxim Uvarov <muvarov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       davidsen@tmr.com, randy.dunlap@oracle.com, dada1@cosmosbay.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
Message-ID: <20070415201024.GB12012@ucw.cz>
References: <461A4C1E.3070309@ru.mvista.com> <20070415094706.GB10097@ucw.cz> <20070415102157.GB2986@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415102157.GB2986@holomorphy.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sun 2007-04-15 03:21:57, William Lee Irwin III wrote:
> At some point in the past, someone's attribution was stripped from:

Maxim's.

> >> +       return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
> >> +                           "Nivcsw:\t%lu\n",
> >> +                           p->nvcsw,
> >> +                           p->nivcsw);
> 
> On Sun, Apr 15, 2007 at 09:47:07AM +0000, Pavel Machek wrote:
> > We don't encrypt variable names like this.
> 
> nvcsw and nivcsw are conventional variable names for these quantities.

I can't decipher them and would not want users see them in /proc.


Would nonvoluntary_ctxt_switch be that much worse?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
