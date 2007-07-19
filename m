Return-Path: <linux-kernel-owner+w=401wt.eu-S934907AbXGSIhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934907AbXGSIhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbXGSIgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:36:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755321AbXGSIgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:36:50 -0400
Date: Thu, 19 Jul 2007 01:36:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cmpxchg is not available to generic code
Message-Id: <20070719013615.948c52d6.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707190917330.21859@skynet.skynet.ie>
References: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707190900320.19586@skynet.skynet.ie>
	<20070719011055.1392c7d2.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707190917330.21859@skynet.skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 09:19:10 +0100 (IST) Dave Airlie <airlied@linux.ie> wrote:

> >
> >> they need to grow a userpsace
> >> cmpxchg as davem mentioned to go along with this, changing the drm now
> >> isn't possible due to backwards compat..
> >
> > For reference purposes, that position is not acceptable.  We _never_ accept the
> > "oh I can't change my proposed kernel interface because I already have
> > userspace relying on it" argument.
> 
> Yes it is, I thought breaking userspace API was the worst crime in kernel 
> history, (unless you are sysfs...) the userspace DRM has been around since 
> 2.2 days at least, so there are lots of legacy userspaces to break..

oh, sorry, I thought this cmpxchg stuff was newly-added.

I guess something changed which has now made DRM available under arm
allmodconfig.


