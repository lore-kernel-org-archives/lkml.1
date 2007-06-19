Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbXFSIz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbXFSIz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbXFSIzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:55:19 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:31676 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXFSIzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:55:18 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Arjan van de Ven <arjan@infradead.org>
Cc: Gerrit Huizenga <gh@us.ibm.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>,
       pavel@ucw.cz
In-Reply-To: <1182216982.3014.1.camel@laptopd505.fenrus.org>
References: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com>
	 <1182171354.11400.40.camel@localhost.localdomain>
	 <1182172374.28566.1.camel@laptopd505.fenrus.org>
	 <1182174836.11400.64.camel@localhost.localdomain>
	 <1182216982.3014.1.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Organization: IBM
Date: Tue, 19 Jun 2007 10:51:28 +0200
Message-Id: <1182243088.11540.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 18:36 -0700, Arjan van de Ven wrote:
> On Mon, 2007-06-18 at 15:53 +0200, holzheu wrote:
> > On Mon, 2007-06-18 at 06:12 -0700, Arjan van de Ven wrote:
> > > On Mon, 2007-06-18 at 14:55 +0200, holzheu wrote:
> > > > Hi Gerrit,
> > > > 
> > > > The common thing of your and our approach is, that we need an ID to
> > > > identify a message either by:
> > > 
> > > 
> > > Maybe I am missing something big, but why is an ID needed?
> > > The message IS the ID right? That's the only thing that is robust
> > > against code moving about....
> > 
> > Yes. As already discussed with Pavel, it is one option to use the format
> > string of the message as message ID. The disadvantage compared to
> > message IDs like hashes is, that format strings might be even less
> > unique than hashes 
> 
> if the hash comes from the string in the first place I have a hard time
> believing that.
> 

Just think of all messages containing %s, which can expand to every
possible string.

Michael

