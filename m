Return-Path: <linux-kernel-owner+w=401wt.eu-S1764509AbXFSB4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764509AbXFSB4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 21:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758907AbXFSB4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 21:56:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34357 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbXFSB4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 21:56:07 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: Arjan van de Ven <arjan@infradead.org>
To: holzheu@linux.vnet.ibm.com
Cc: Gerrit Huizenga <gh@us.ibm.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>,
       pavel@ucw.cz
In-Reply-To: <1182174836.11400.64.camel@localhost.localdomain>
References: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com>
	 <1182171354.11400.40.camel@localhost.localdomain>
	 <1182172374.28566.1.camel@laptopd505.fenrus.org>
	 <1182174836.11400.64.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 18 Jun 2007 18:36:22 -0700
Message-Id: <1182216982.3014.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 15:53 +0200, holzheu wrote:
> On Mon, 2007-06-18 at 06:12 -0700, Arjan van de Ven wrote:
> > On Mon, 2007-06-18 at 14:55 +0200, holzheu wrote:
> > > Hi Gerrit,
> > > 
> > > The common thing of your and our approach is, that we need an ID to
> > > identify a message either by:
> > 
> > 
> > Maybe I am missing something big, but why is an ID needed?
> > The message IS the ID right? That's the only thing that is robust
> > against code moving about....
> 
> Yes. As already discussed with Pavel, it is one option to use the format
> string of the message as message ID. The disadvantage compared to
> message IDs like hashes is, that format strings might be even less
> unique than hashes 

if the hash comes from the string in the first place I have a hard time
believing that.

> and it's probably less convenient for searching by
> operators.

I'm not convinced of that...

> 
> An operator has to issue either:
> 
> >> info lp.4711
> or
> >> info "lp0: on fire"

well.... surely the messages are caught by some userspace program,
right? (like syslog).. that can do the lookup and make it all
conveniently lookup-able and cross-referencable etc etc....

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

