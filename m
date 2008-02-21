Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbYBUQEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbYBUQEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934495AbYBUQDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:03:01 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:25408 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933760AbYBUQC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:02:59 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>,
       "thenzl@redhat.com" <thenzl@redhat.com>,
       "coldwell@redhat.com" <coldwell@redhat.com>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>
Date: Thu, 21 Feb 2008 16:02:05 +0000
Subject: RE: [PATCH 1/1] resubmit: cciss: procfs updates to display info
 about many volumes
Thread-Topic: [PATCH 1/1] resubmit: cciss: procfs updates to display info
 about many volumes
Thread-Index: Ach0X3aHsUTBUh3YSNW2qs5VKCDKFwAQ4Qtw
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE0428114F45@G6W0268.americas.hpqcorp.net>
References: <20080220214400.GA13443@roadking.usa.hp.com>
 <20080221075743.GE23197@kernel.dk>
In-Reply-To: <20080221075743.GE23197@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens wrote:
>
> On Wed, Feb 20 2008, Mike Miller wrote:
> > Patch 1 of 1
> >
> > This patch hopefully fixes all the brokeness in my last
> submission. It
> > compiles cleanly with tape support on or off. I added a couple of
> > #ifdef's and removed the broken macro definition. The
> #ifdef's made it unneccesary.
> > It also replaces create_proc_read_entry with proc_create.
> >
> > This patch allows us to display information about all of
> the logical
> > volumes configured on a particular controller without stepping on
> > memory even when there are many volumes (128 or more) configured.
> > Please consider this for inclusion.
>
> Looks a lot better, I've applied it.
>

Thanks.
