Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbYCGWLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbYCGWLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYCGWLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:11:24 -0500
Received: from mx1.riseup.net ([204.13.164.18]:42764 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYCGWLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:11:24 -0500
Date: Fri, 7 Mar 2008 23:11:17 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pcmcia@lists.infradead.org, nico@cam.org, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/pcmcia/soc_common.c: convert
	soc_pcmcia_sockets_lock in a mutex
Message-ID: <20080307221117.GG2783@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-pcmcia@lists.infradead.org, nico@cam.org,
	rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <20080307183742.GF2783@traven> <20080307111642.8278142f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307111642.8278142f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, Mar 07, 2008 at 11:16:42AM -0800 Andrew Morton ha dit:

> On Fri, 7 Mar 2008 19:37:42 +0100 Matthias Kaehlcke <matthias@kaehlcke.net> wrote:
> 
> > drivers/pcmcia/soc_common.c: the semaphore soc_pcmcia_sockets_lock is
> > used as a mutex, convert it to the mutex API
> > 
> 
> I did this yesterday, when I saw it while grepping around due to your other
> patch;)

:)
 
-- 
Matthias Kaehlcke
Linux System Developer
Barcelona


 Someone has said that it requires less mental effort to condemn than to think
                             (Emma Goldman)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
