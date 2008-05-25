Return-Path: <linux-kernel-owner+w=401wt.eu-S1760527AbYEYArt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527AbYEYArt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 20:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYEYArl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 20:47:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbYEYArk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 20:47:40 -0400
Date: Sat, 24 May 2008 20:47:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Clark Williams <clark.williams@gmail.com>
cc: Steven Rostedt <srostedt@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH -rt] fix for compiling 2.6.24.7-rt10 without CONFIG_FTRACE
In-Reply-To: <48387154.8070204@gmail.com>
Message-ID: <Pine.LNX.4.58.0805242047130.3977@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805240221080.1841@gandalf.stny.rr.com>
 <48387154.8070204@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 24 May 2008, Clark Williams wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Steven,
>
> If you build a debugging kernel and don't have CONFIG_FTRACE turned on, -rt10 dies
> when compiling arch/x86/kernel/x8664_ksyms_64.c, because ktime_t isn't defined in the
> prototypes at the bottom of include/linux/ftrace.h. Patch to fix attached.
>

Ah, you sent me this before, but I thought it was fixed with the new
ftrace. Sorry, I'll re-apply it.

Thanks.

-- Steve

