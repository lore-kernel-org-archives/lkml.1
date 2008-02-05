Return-Path: <linux-kernel-owner+w=401wt.eu-S1762215AbYBEWW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215AbYBEWW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbYBEWWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:22:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbYBEWWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:22:15 -0500
Date: Tue, 5 Feb 2008 14:19:44 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, "James Morris" <jmorris@namei.org>,
       linux-usb@vger.kernel.org, zaitcev@redhat.com
Subject: Re: [2.6.24 REGRESSION] BUG: Soft lockup - with VFS
Message-Id: <20080205141944.773140a1.zaitcev@redhat.com>
In-Reply-To: <20080205140506.c6354490.akpm@linux-foundation.org>
References: <6101e8c40801280031v1a860e90gfb3992ae5db37047@mail.gmail.com>
	<20080204213911.1bcbaf66.akpm@linux-foundation.org>
	<1202219216.27371.24.camel@moss-spartans.epoch.ncsc.mil>
	<20080205104028.190192b1.akpm@linux-foundation.org>
	<6101e8c40802051115v12d3c02br24873ef1014dbea9@mail.gmail.com>
	<6101e8c40802051321l13268239m913fd90f56891054@mail.gmail.com>
	<6101e8c40802051348w2250e593x54f777bb771bd903@mail.gmail.com>
	<20080205140506.c6354490.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 14:05:06 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> Looks like you deadlocked in ub_request_fn().  I assume that you were using
> ub.c in 2.6.23 and that it worked OK?  If so, we broke it, possibly via
> changes to the core block layer.
> 
> I think ub.c is basically abandoned in favour of usb-storage.  If so,
> perhaps we should remove or disble ub.c?

Actually I think it may be an argument for keeping ub, if ub exposes
a bug in the __blk_end_request. I'll look at the head of the thread
and see if Mr. Pinter has hit anything related to Mr. Ueda's work.

-- Pete
