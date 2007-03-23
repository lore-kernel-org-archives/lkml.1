Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbXCWBlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbXCWBlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934267AbXCWBlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:41:08 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:34657 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739AbXCWBlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:41:05 -0400
Date: Fri, 23 Mar 2007 02:38:25 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stephane Eranian <eranian@hpl.hp.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: kmalloc() with size zero
In-Reply-To: <20070323001824.GA26540@frankl.hpl.hp.com>
Message-ID: <Pine.LNX.4.61.0703230237390.9555@yvahk01.tjqt.qr>
References: <20070323001824.GA26540@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 22 2007 16:18, Stephane Eranian wrote:
>
>Hello,
>
>I ran into an issue with perfmon where I ended up calling
>kmalloc() with a size of zero. To my surprise, this did
>not return NULL but a valid data address.
>
>I am wondering if this is a property of kmalloc() or simply
>a bug. It is the case that the __kmalloc() code does not
>check for zero size.

I'd say "feature", glibc's malloc also returns an address on malloc(0).


Jan
-- 
