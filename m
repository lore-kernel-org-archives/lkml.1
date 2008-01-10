Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbYAJPqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbYAJPqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbYAJPpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:45:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbYAJPpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:45:50 -0500
Date: Thu, 10 Jan 2008 10:45:43 -0500
From: Rik van Riel <riel@redhat.com>
To: "Anton Salikhmetov" <salikhmetov@gmail.com>
Cc: "Jakob Oestergaard" <jakob@unthought.net>,
       "Anton Salikhmetov" <salikhmetov@gmail.com>, Valdis.Kletnieks@vt.edu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in
 msync()
Message-ID: <20080110104543.398baf5c@bree.surriel.com>
In-Reply-To: <4df4ef0c0801100253m6c08e4a3t917959c030533f80@mail.gmail.com>
References: <1199728459.26463.11.camel@codedot>
	<20080109155015.4d2d4c1d@cuia.boston.redhat.com>
	<26932.1199912777@turing-police.cc.vt.edu>
	<20080109170633.292644dc@cuia.boston.redhat.com>
	<20080109223340.GH25527@unthought.net>
	<20080109184141.287189b8@bree.surriel.com>
	<4df4ef0c0801091603y2bf507e1q2b99971c6028d1f3@mail.gmail.com>
	<20080110085120.GK25527@unthought.net>
	<4df4ef0c0801100253m6c08e4a3t917959c030533f80@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 13:53:59 +0300
"Anton Salikhmetov" <salikhmetov@gmail.com> wrote:

> Indeed, if msync() is called with MS_SYNC an explicit sync is
> triggered, and Rik's suggestion would work. However, the POSIX
> standard requires a call to msync() with MS_ASYNC to update the
> st_ctime and st_mtime stamps too. No explicit sync of the inode data
> is triggered in the current implementation of msync(). Hence Rik's
> suggestion would fail to satisfy POSIX in the latter case.

Since your patch is already changing msync(), has it occurred
to you that your patch could change msync() to do the right
thing?

-- 
All rights reversed.
