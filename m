Return-Path: <linux-kernel-owner+w=401wt.eu-S1031718AbXEDVsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031718AbXEDVsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031721AbXEDVsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:48:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031720AbXEDVsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:48:02 -0400
Date: Fri, 4 May 2007 14:47:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Remove constructor from buffer_head
Message-Id: <20070504144756.90d3b41d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705041439040.25764@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
	<20070504134212.c18d2d65.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705041439040.25764@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 14:42:02 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 4 May 2007, Andrew Morton wrote:
> 
> > So the patch took the average system time from 4.42 seconds up to 4.582
> > seconds.  Nice slowdown!
> 
> All of that from a memset and a list head init on a cacheline we already 
> use?

Seems unlikely, especially when you consider all the other stuff which a write()
has to do.
