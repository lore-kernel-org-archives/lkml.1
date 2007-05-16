Return-Path: <linux-kernel-owner+w=401wt.eu-S1762037AbXEPLkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762037AbXEPLkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbXEPLkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:40:36 -0400
Received: from smtp.nokia.com ([131.228.20.171]:64569 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212AbXEPLkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:40:35 -0400
Subject: Re: [PATCH] LogFS take three
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Jamie Lokier <jamie@shareable.org>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>, akpm@osdl.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
       John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       Ingo Oeser <ioe-lkml@rameria.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mtd@lists.infradead.org, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070516113434.GC20482@mail.shareable.org>
References: <20070515151919.GA32510@lazybastard.org>
	 <17994.1241.436841.681216@stoffel.org>
	 <20070515191926.GB1220@lazybastard.org>
	 <1179291255.2859.195.camel@shinybook.infradead.org>
	 <20070516110933.GA5472@lazybastard.org>
	 <20070516113434.GC20482@mail.shareable.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 16 May 2007 14:38:18 +0300
Message-Id: <1179315498.3642.19.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 May 2007 11:38:18.0784 (UTC) FILETIME=[B3135200:01C797AE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 12:34 +0100, Jamie Lokier wrote:
> Jörn Engel wrote:
> > On Wed, 16 May 2007 12:54:14 +0800, David Woodhouse wrote:
> > > Personally I'd just go for 'JFFS3'. After all, it has a better claim to
> > > the name than either of its predecessors :)
> > 
> > Did you ever see akpm's facial expression when he tried to pronounce
> > "JFFS2"?  ;)
> 
> JFFS3 is a good, meaningful name to anyone familiar with JFFS2.
> 
> But if akpm can't pronounce it, how about FFFS for faster flash
> filesystem.... ;-)

The problem is that JFFS2 will always be faster in terms of I/O speed
anyway, just because it does not have to maintain on-flash indexing
data structures. But yes, it is slow in mount and in building big
inodes, so the "faster" is confusing.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

