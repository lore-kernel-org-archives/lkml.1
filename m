Return-Path: <linux-kernel-owner+w=401wt.eu-S1751081AbYISNIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081AbYISNIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 09:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYISNIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 09:08:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:35003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbYISNIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 09:08:06 -0400
Date: Fri, 19 Sep 2008 06:07:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Oruba <peter.oruba@amd.com>
Cc: cate@debian.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch 05/11] [PATCH 05/11] x86: Moved microcode.c to
 microcode_intel.c.
Message-ID: <20080919060752.57542a50@infradead.org>
In-Reply-To: <48D3942B.1050901@amd.com>
References: <20080728164411.490752571@amd.com>
	<20080728164448.492961653@amd.com>
	<20080907120823.59f8fa47@infradead.org>
	<48CA586C.2010104@amd.com>
	<20080912063517.783b7f85@infradead.org>
	<48D3942B.1050901@amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 13:59:39 +0200
Peter Oruba <peter.oruba@amd.com> wrote:

> Some additonal words regarding the current user space issues:
> 
> IMHO the most convenient way to update microcode is through the
> firmware loading interface instead of microcode_ctl. This reduces
> user-space responsibilities to loading the correct module at boot
> time and to place the microcode patch file at the right location via
> package installation. The problems mentioned in this thread would
> then probably disappear as well. What do you guys think?

while I absolutely don't disagree with what you say, breaking existing
userspace is not an option.
Yes I very much would like for microcode_ctl to die as well (in fact,
that was one of the reasons we had the microcode code use
request_firmware), but that doesn't mean we can just ditch
compatibility ;(
