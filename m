Return-Path: <linux-kernel-owner+w=401wt.eu-S1764189AbXGZGLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764189AbXGZGLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 02:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbXGZGLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 02:11:47 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:50282 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbXGZGLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 02:11:46 -0400
Date: Thu, 26 Jul 2007 15:11:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What's does KPROBE_ENTRY mean?
Message-ID: <20070726061117.GA25926@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	jidong xiao <jidong.xiao@gmail.com>, linux-kernel@vger.kernel.org
References: <4104961b0706202213p16df5ca5s579de4b949efbf16@mail.gmail.com> <4104961b0707252243l41addce8wca35d19c5de729ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4104961b0707252243l41addce8wca35d19c5de729ee@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 01:43:10PM +0800, jidong xiao wrote:
> Anyone can help this?
> 
> On 6/21/07, jidong xiao <jidong.xiao@gmail.com> wrote:
> > I searched in linux kernel 2.6.10, didn't find it, then I tried
> > 2.6.20, it is there. But I am not familiar with assembly language, so
> > can anybody kindly explain it, I don't know the difference between
> > KPROBE_ENTRY and ENTRY, however, I can find both of these items in
> > some files, such as arch/x86_64/kernel/entry.S.
> >
KPROBE_ENTRY() is the assembly equivalent of __kprobes, it places the
symbol in a special section (.kprobes.text) where probes can't be
inserted. This is usually helpful in cases where inserting the probe may
lead to recursion or other undesirable behaviour.

See include/linux/linkage.h and include/linux/kprobes.h.
