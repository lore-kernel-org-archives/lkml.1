Return-Path: <linux-kernel-owner+w=401wt.eu-S1763234AbXFRNTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763234AbXFRNTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbXFRNTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:19:48 -0400
Received: from styx.suse.cz ([82.119.242.94]:49780 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757641AbXFRNTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:19:48 -0400
Date: Mon, 18 Jun 2007 15:33:11 +0200
From: Jan Kara <jack@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: holzheu@linux.vnet.ibm.com, Gerrit Huizenga <gh@us.ibm.com>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, gregkh@suse.de,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070618133311.GK9319@duck.suse.cz>
References: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com> <1182171354.11400.40.camel@localhost.localdomain> <1182172374.28566.1.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182172374.28566.1.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-06-07 06:12:54, Arjan van de Ven wrote:
> On Mon, 2007-06-18 at 14:55 +0200, holzheu wrote:
> > Hi Gerrit,
> > 
> > The common thing of your and our approach is, that we need an ID to
> > identify a message either by:
> 
> 
> Maybe I am missing something big, but why is an ID needed?
> The message IS the ID right? That's the only thing that is robust
> against code moving about....
  I think the problem is messages contain device numbers, and all similar
kind of data. So what you'd really like is to use >format string< as ID.
But that is not easily accessible for the user, so you'd have to print it
with each message. And that's ... ugly IMHO.

> (And yes I am aware that very occasionally there might be a duplicate
> message that REALLY is different, but I suspect that that is so
> incredibly rare that it's just simpler to reword one of the two in such
> case)

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
