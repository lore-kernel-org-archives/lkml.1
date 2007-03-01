Return-Path: <linux-kernel-owner+w=401wt.eu-S965045AbXCAOEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbXCAOEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbXCAOEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:04:05 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:55840 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbXCAOEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:04:04 -0500
Date: Thu, 1 Mar 2007 23:01:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC 2.6.20 1/2] fbdev, mm: Deferred IO support
Message-ID: <20070301140131.GA6603@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jaya Kumar <jayakumar.lkml@gmail.com>,
	linux-fbdev-devel@lists.sourceforge.net, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070225051312.17454.80741.sendpatchset@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225051312.17454.80741.sendpatchset@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 06:13:12AM +0100, Jaya Kumar wrote:
> This patch implements deferred IO support in fbdev. Deferred IO is a way to
> delay and repurpose IO. This implementation is done using mm's page_mkwrite
> and page_mkclean hooks in order to detect, delay and then rewrite IO. This
> functionality is used by hecubafb.
> 
Any updates on this? If there are no other concerns, it would be nice to
at least get this in to -mm for testing if nothing else.

Jaya, can you roll the fsync() patch in to your defio patch? There's not
much point in keeping them separate.
