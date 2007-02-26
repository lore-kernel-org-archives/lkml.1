Return-Path: <linux-kernel-owner+w=401wt.eu-S1161408AbXBZXnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161408AbXBZXnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161410AbXBZXnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:43:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40601
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161408AbXBZXnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:43:10 -0500
Date: Mon, 26 Feb 2007 15:43:08 -0800 (PST)
Message-Id: <20070226.154308.112620497.davem@davemloft.net>
To: hpa@zytor.com
Cc: a.gruenbacher@computer.org, nathans@sgi.com, bunk@stusta.de,
       linux-kernel@vger.kernel.org, jmorris@redhat.com, dwmw2@infradead.org
Subject: Re: include/linux/xattr.h: how much userpace visible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <45E36D39.2030605@zytor.com>
References: <20060724085701.B2083275@wobbly.melbourne.sgi.com>
	<200607242031.11815.a.gruenbacher@computer.org>
	<45E36D39.2030605@zytor.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 26 Feb 2007 15:28:57 -0800

> Andreas Gruenbacher wrote:
> > On Monday, 24 July 2006 00:57, Nathan Scott wrote:
> >> On Sun, Jul 23, 2006 at 08:43:43PM +0200, Adrian Bunk wrote:
> >>> Hi,
> >>>
> >>> how much of include/linux/xattr.h has to be part of the userspace kernel
> >>> headers?
> >> None, I think.
> > 
> > None, indeed. The attr package comes with it own version of xattr.h that also 
> > includes definitions of XATTR_CREATE and XATTR_REPLACE.
> > 
> 
> However, it would be better if the ABI constants were exported, or at 
> least *exportable* (using a __KERNEL_XATTR_MACROS test macro or 
> something like that.)

This is the same situation as the socket.h issue we're trying
to figure out what to do about.

wrt. the socket.h case I think I'm going to revert the guilty
changeset for now until a better scheme is implemented
