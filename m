Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbXDTGse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbXDTGse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 02:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbXDTGse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 02:48:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333AbXDTGsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 02:48:33 -0400
Date: Thu, 19 Apr 2007 23:48:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Andrew de Quincey <adq_dvb@lidskialf.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] dvb_en_50221: Convert to kthread API
Message-Id: <20070419234809.894769e1.akpm@linux-foundation.org>
In-Reply-To: <20070420063714.GA5205@infradead.org>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<1176969639190-git-send-email-ebiederm@xmission.com>
	<20070419153413.8768fd1d.akpm@linux-foundation.org>
	<20070420063714.GA5205@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 07:37:14 +0100 Christoph Hellwig <hch@infradead.org> wrote:

> > urgh, yes, this is just sad.  We should convert this driver fully to
> > the kthread API - it will end up much better.
> > 
> > I'll queue this up as a -mm-only thing as a gentle reminder that
> > we should do it properly.
> 
> Here's an attempted update to the full kthread API + wake_up_process:

 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |   84 +++---------------
 1 file changed, 16 insertions(+), 68 deletions(-)

tasty!
