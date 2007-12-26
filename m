Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbXLZTh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbXLZTh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 14:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXLZTht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 14:37:49 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:56179 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbXLZThs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 14:37:48 -0500
Date: Wed, 26 Dec 2007 20:19:13 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] fs/autofs: Use time_before, time_before_eq, etc.
In-Reply-To: <477293F3.60304@zytor.com>
Message-ID: <Pine.LNX.4.64.0712262016230.22244@ask.diku.dk>
References: <Pine.LNX.4.58.0712261621000.1185@pc-041.diku.dk> <477293F3.60304@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2007, H. Peter Anvin wrote:

> Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > The functions time_before, time_before_eq, time_after, and time_after_eq
> > are more robust for comparing jiffies against other values.
> > 
> 
> More robust, how?  You already almost introduced a bug here...

I'm just summarizing the comment that goes with the definition of the 
time_after etc functions:

include/linux/jiffies.h:88
/*
 *	These inlines deal with timer wrapping correctly. You are 
 *	strongly encouraged to use them
 *	1. Because people otherwise forget
 *	2. Because if the timer wrap changes in future you won't have to
 *	   alter your driver code.
 *

julia
