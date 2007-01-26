Return-Path: <linux-kernel-owner+w=401wt.eu-S1161232AbXAZTsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232AbXAZTsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161234AbXAZTsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:48:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52099 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161232AbXAZTsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:48:14 -0500
Date: Fri, 26 Jan 2007 11:48:05 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Matthew Kirk" <mkirk01@rcn.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: fsync occasionally very slow
Message-Id: <20070126114805.628f1351.akpm@osdl.org>
In-Reply-To: <000c01c74180$dfe71070$6600a8c0@charm>
References: <001a01c74136$0028ecf0$6600a8c0@charm>
	<20070126031654.a41fe374.akpm@osdl.org>
	<000c01c74180$dfe71070$6600a8c0@charm>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 14:33:36 -0500
"Matthew Kirk" <mkirk01@rcn.com> wrote:

> Sorry, this will show my ignorance...  my system is lacking
> /proc/sysrq-trigger.  I can find how to build a kernel with the magic sysrq
> key (CONFIG_MAGIC_SYSRQ=y), and have done so, but I still don't have
> /proc/sysrq-* and cannot seem to find how to build in sysrq functionality
> itself - assuming that's what's missing.  Presumably it's something in
> .config I'm just not seeing?
> 

I think you're running a prehistoric kernel which might predate
/proc/sysrq-trigger?

You can get the same effect by typing alt-sysrq-t at the right time (or
whatever the combination is on that machine).
