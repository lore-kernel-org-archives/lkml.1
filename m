Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbZG3Wni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbZG3Wni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbZG3Wni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:43:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35277 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZG3Wnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:43:37 -0400
In-Reply-To: <20090730210946.GA14722@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Subject: Re: [Patch RFC 20/37] cifs: convert semaphore to mutex
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFCF5697D2.8DF82A35-ON87257603.007CB218-86257603.007CED01@us.ibm.com>
From: Steven French <sfrench@us.ibm.com>
Date: Thu, 30 Jul 2009 17:43:32 -0500
X-MIMETrack: Serialize by Router on D03NM123/03/M/IBM(Release 8.0.1|February 07, 2008) at
 07/30/2009 16:43:34,
	Serialize complete at 07/30/2009 16:43:34
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote on 07/30/2009 04:09:46 PM:

> On Sun, Jul 26, 2009 at 08:18:39AM -0000, Thomas Gleixner wrote:
> > -   struct semaphore sesSem;
> > +   struct mutex sesSem;
> 
> If we touch every user of this anyway any chance we could give it a sane
> name, e.g. session_mutex?
> 

Sounds like a good idea.  Might as well make the name change - since it is 
easier to read.


Steve French
Senior Software Engineer
Linux Technology Center - IBM Austin
phone: 512-838-2294
email: sfrench at-sign us dot ibm dot com
