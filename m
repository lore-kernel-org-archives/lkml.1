Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbYFDQiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbYFDQiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYFDQiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:38:15 -0400
Received: from mx1.riseup.net ([204.13.164.18]:32825 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYFDQiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:38:14 -0400
Date: Wed, 4 Jun 2008 18:38:06 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 1/2] MTD: use list_for_each_entry() in add_mtd_device()
Message-ID: <20080604163806.GA28628@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20080531132808.644758754@kaehlcke.net> <20080531132808.984625508@kaehlcke.net> <1212597248.32207.126.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1212597248.32207.126.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, Jun 04, 2008 at 05:34:08PM +0100 David Woodhouse ha dit:

> On Sat, 2008-05-31 at 15:28 +0200, matthias@kaehlcke.net wrote:
> > -                       struct list_head *this;
> > +                       struct mtd_notifier *not
> 
> That's not even going to compile, surely?

i forgot to tell quilt to refresh the patch before sending it. i sent
a fix just some minutes after the broken patch

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
