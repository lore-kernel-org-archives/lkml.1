Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbZE0VO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbZE0VO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760209AbZE0VOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:14:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34303 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760537AbZE0VOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:14:16 -0400
Date: Wed, 27 May 2009 22:15:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [1/16] HWPOISON: Add page flag for poisoned pages
Message-ID: <20090527221510.5e418e97@lxorguk.ukuu.org.uk>
In-Reply-To: <20090527201226.CCCBB1D028F@basil.firstfloor.org>
References: <200905271012.668777061@firstfloor.org>
	<20090527201226.CCCBB1D028F@basil.firstfloor.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 22:12:26 +0200 (CEST)
Andi Kleen <andi@firstfloor.org> wrote:

> 
> Hardware poisoned pages need special handling in the VM and shouldn't be 
> touched again. This requires a new page flag. Define it here.

Why can't you use PG_reserved ? That already indicates the page may not
even be present (which is effectively your situation at that point).
Given lots of other hardware platforms we support bus error, machine
check, explode or do random undefined fun things when you touch pages
that don't exist I'm not sure I see why poisoned is different here ?

Alan
