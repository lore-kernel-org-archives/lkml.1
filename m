Return-Path: <linux-kernel-owner+w=401wt.eu-S1751641AbXAXOlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbXAXOlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 09:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbXAXOlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 09:41:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:40346 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751636AbXAXOlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 09:41:15 -0500
X-Authenticated: #5039886
Date: Wed, 24 Jan 2007 15:41:11 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ian Kumlien <pomac@vapor.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Larry Walton <lwalton@real.com>, s0348365@sms.ed.ac.uk, chunkeey@web.de,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: SATA exceptions with 2.6.20-rc5
Message-ID: <20070124144111.GC2117@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Ian Kumlien <pomac@vapor.com>, Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Larry Walton <lwalton@real.com>, s0348365@sms.ed.ac.uk,
	chunkeey@web.de, Jeff Garzik <jeff@garzik.org>
References: <fa.1kBz5luWz8nR0lLqm1VD4hZZYdw@ifi.uio.no> <fa.QZxgjxcwtENaZNY24NMTlKBSgIM@ifi.uio.no> <fa.fkPTbUGmKc/1pt0eD6TE4d02n+Q@ifi.uio.no> <fa.6iQt5OtHZ3x5w8eYbLxwULhLTJ0@ifi.uio.no> <fa.1aqo3IxNGJClHcBVZNTagX6bL9o@ifi.uio.no> <fa.rI60BGlFbSyfLyumqmgiOfDqCI4@ifi.uio.no> <45B697D3.4070707@shaw.ca> <1169627043.11590.1.camel@pi.pomac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1169627043.11590.1.camel@pi.pomac.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.01.24 09:24:00 +0100, Ian Kumlien wrote:
> On tis, 2007-01-23 at 17:18 -0600, Robert Hancock wrote:
> > Larry Walton wrote:
> > > The last patch (sata_nv-force-int-dev-in-interrupt.patch) 
> > > seems to have fix the problem.  Much appreciated, 
> > > thank you. I'd consider it a must have in 2.6.20.
> > 
> > Can any of the rest of you that have been seeing this problem also 
> > confirm that this fixes it?
> 
> I applied it yesterday and today my dmesg contains three:
> BUG: at mm/truncate.c:60 cancel_dirty_page()

David Chinner sent two patches regarding that bug yesterday.
http://lkml.org/lkml/2007/1/23/190
http://lkml.org/lkml/2007/1/23/192

Björn
