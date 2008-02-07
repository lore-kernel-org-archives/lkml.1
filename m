Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYBGRyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYBGRyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbYBGRyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:54:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:65402 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbYBGRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=K+rFfBuKZiz0KyIMkVatDrcI0tBIuHqLXdG5cKDspo3hjdS6BLfr412+7o1DYKz2OdByLV6TS6SXzC6JA7GshnSNmipldFTNWnFa9mWpvFjlkq/c49KLv3FdiixqQxmWA6tG3u96vA30eHSYBIGg81Fh5O0NDUCcoiJdSrBybEs=
Subject: Re: [PATCH 2/8] Add interface for queuing work on a specific CPU
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com,
       npiggin@suse.de, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20080207094928.GB15220@kernel.dk>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
	 <1202375945-29525-3-git-send-email-jens.axboe@oracle.com>
	 <20080207014503.cf1853c2.akpm@linux-foundation.org>
	 <20080207094928.GB15220@kernel.dk>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 09:44:52 -0800
Message-Id: <1202406320.22452.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-07 at 10:49 +0100, Jens Axboe wrote:
> On Thu, Feb 07 2008, Andrew Morton wrote:
> > On Thu,  7 Feb 2008 10:18:59 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > ---
> > >  include/linux/workqueue.h |    1 +
> > >  kernel/workqueue.c        |   15 +++++++++++++++
> > >  2 files changed, 16 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> > > index 7f28c32..4c46944 100644
> > > --- a/include/linux/workqueue.h
> > > +++ b/include/linux/workqueue.h
> > > @@ -179,6 +179,7 @@ __create_workqueue_key(const char *name, int singlethread,
> > >  extern void destroy_workqueue(struct workqueue_struct *wq);
> > >  
> > >  extern int FASTCALL(queue_work(struct workqueue_struct *wq, struct work_struct *work));
> > > +extern int FASTCALL(queue_work_on_cpu(struct workqueue_struct *wq, struct work_struct *work, int cpu));
> > 
> > -ETOOWIDE
> > 
> > please don't add fastcall - we're trying to remove it.
> 
> Oops yes, I'll kill the fastcall and fix the > 80 char line!
> 

I'll be making another round-up patch at -rc1 for FASTCALL/fastcall

FYI

Harvey

