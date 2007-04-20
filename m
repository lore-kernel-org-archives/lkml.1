Return-Path: <linux-kernel-owner+w=401wt.eu-S1766549AbXDTJhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766549AbXDTJhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766556AbXDTJhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:37:18 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:64889 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766549AbXDTJhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:37:15 -0400
Message-ID: <462889C6.2000201@fr.ibm.com>
Date: Fri, 20 Apr 2007 11:37:10 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Andrew de Quincey <adq_dvb@lidskialf.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] dvb_en_50221: Convert to kthread API
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969639190-git-send-email-ebiederm@xmission.com> <20070419153413.8768fd1d.akpm@linux-foundation.org> <20070420063714.GA5205@infradead.org> <20070419234809.894769e1.akpm@linux-foundation.org>
In-Reply-To: <20070419234809.894769e1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 20 Apr 2007 07:37:14 +0100 Christoph Hellwig <hch@infradead.org> wrote:
> 
>>> urgh, yes, this is just sad.  We should convert this driver fully to
>>> the kthread API - it will end up much better.
>>>
>>> I'll queue this up as a -mm-only thing as a gentle reminder that
>>> we should do it properly.
>> Here's an attempted update to the full kthread API + wake_up_process:
> 
>  drivers/media/dvb/dvb-core/dvb_ca_en50221.c |   84 +++---------------
>  1 file changed, 16 insertions(+), 68 deletions(-)
> 
> tasty!

Indeed !

I have sent a similar patch a few months ago :

	http://lkml.org/lkml/2007/1/24/178

with a less aggressive diffstat though :) 

Andrew (de Quincey) just drop mine, if you haven't already done. Christoph's is
more recent and looks better.

Thanks,

C.
