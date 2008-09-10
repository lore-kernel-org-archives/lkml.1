Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbYIJXY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbYIJXY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYIJXYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:24:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbYIJXYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:24:13 -0400
Date: Wed, 10 Sep 2008 16:24:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: davem@davemloft.net, jeffm@suse.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-Id: <20080910162404.a3208b8f.akpm@linux-foundation.org>
In-Reply-To: <1221088512.13621.58.camel@macbook.infradead.org>
References: <48C68507.6000609@suse.com>
	<1221087719.13621.50.camel@macbook.infradead.org>
	<20080910.160505.14060698.davem@davemloft.net>
	<1221088512.13621.58.camel@macbook.infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 16:15:11 -0700
David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2008-09-10 at 16:05 -0700, David Miller wrote:
> > 
> > Tell that to every Debian and Debian derived system on the planet.
> > 
> > To my knowledge, it is only fedora and possibly one or two other dists
> > that put the firmware files in a unary /lib/firmware location, rather
> > than a versioned /lib/firmware/$KERNELRELASE one.
> 
> So every time they upgrade from one kernel to the next, do they
> automatically run b43-fwcutter again to make a new copy of the firmware,
> for the new kernel?
> 
> Or if they use QLogic SCSI cards, do they download a new (but identical)
> version of the firmware each time they upgrade their kernel?
> 
> It sounds like a daft arrangement to me -- although of course it's
> possible for the packager to do whatever they like, by overriding
> $(INSTALL_FW_PATH) in their package build.
> 
> It's definitely not something we should be doing upstream though.
> 

It all seems a bit academic.  Breaking pre-v127 udev is a showstopper.

A suitable approach might be to copy the files to both /lib/firmware
and to /lib/firmware/$KERNELRELEASE, and to stop copying the files to
/lib/firmware in, oh, 2018 or so..

