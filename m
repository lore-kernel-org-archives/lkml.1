Return-Path: <linux-kernel-owner+w=401wt.eu-S1764721AbYASE0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764721AbYASE0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbYASE0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:26:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758284AbYASE0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:26:40 -0500
Date: Fri, 18 Jan 2008 23:25:19 -0500
From: Rik van Riel <riel@redhat.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Oeser <ioe-lkml@rameria.de>, Miklos Szeredi <miklos@szeredi.hu>,
       peterz@infradead.org, salikhmetov@gmail.com, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, ksm@42.dk, staubach@redhat.com,
       jesper.juhl@gmail.com, akpm@linux-foundation.org, protasnb@gmail.com,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
Message-ID: <20080118232519.4cc65df2@bree.surriel.com>
In-Reply-To: <1200703803.25782.45.camel@cinder.waste.org>
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	<E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>
	<alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
	<200801182332.02945.ioe-lkml@rameria.de>
	<alpine.LFD.1.00.0801181439330.2957@woody.linux-foundation.org>
	<20080118175450.715ded60@bree.surriel.com>
	<1200703803.25782.45.camel@cinder.waste.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 18:50:03 -0600
Matt Mackall <mpm@selenic.com> wrote:
> On Fri, 2008-01-18 at 17:54 -0500, Rik van Riel wrote:

> > Backup programs not seeing an updated mtime is a really big deal.
> 
> And that's fixed with the 4-line approach.
> 
> Reminds me, I've got a patch here for addressing that problem with loop mounts:
> 
> Writes to loop should update the mtime of the underlying file.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
