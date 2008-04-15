Return-Path: <linux-kernel-owner+w=401wt.eu-S1764519AbYDOLiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764519AbYDOLiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbYDOLh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:37:59 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54423 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbYDOLh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:37:58 -0400
Date: Tue, 15 Apr 2008 14:37:56 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Adrian Bunk <bunk@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smb.h: uses struct timespec but didn't include	linux/time.h
In-Reply-To: <20080415112500.GB2454@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0804151429270.17123@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0804151202390.17123@wrl-59.cs.helsinki.fi>
 <20080415021057.9bdff72f.akpm@linux-foundation.org>
 <20080415112500.GB2454@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Adrian Bunk wrote:

> On Tue, Apr 15, 2008 at 02:10:57AM -0700, Andrew Morton wrote:
> > On Tue, 15 Apr 2008 12:04:04 +0300 (EEST) "Ilpo J__rvinen" <ilpo.jarvinen@helsinki.fi> wrote:
> > >  
> > > +#include <linux/time.h>
> > 
> > Did this actually cause a compilation error?
> 
> Even if it doesn't at the moment it should be fixed - these kind
> of issues are why often adding or removing an #include in a header 
> suddenly breaks some configuration on some other architecture.

...I suppose point of Andrew's enquiry was more about determining how 
soon it should be scheduled for inclusion rather than its usefulness.

-- 
 i.
