Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbXCGPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbXCGPNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXCGPNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:13:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34303 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbXCGPNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:13:18 -0500
Subject: Re: How do I analyze a soft lockup?
From: Arjan van de Ven <arjan@infradead.org>
To: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87k5xt40ew.fsf@ABG3595C.abg.fsc.net>
References: <87k5xt40ew.fsf@ABG3595C.abg.fsc.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 07 Mar 2007 07:12:20 -0800
Message-Id: <1173280342.3540.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 15:02 +0100, Rainer Koenig wrote:
> Hi there,
> 
> Environment:
> 
> Kernel is 2.6.16.27, arch x86_64 on a Dual Core AMD64 machine with
> 4 GB of RAM. Also involved is an Areca 1100 SATA RAID controller
> with the drives from the Tekram website. 
> 
> Problem: 
> 
> We get customer reports that a system stops with the following kernel
> messages (as they are submitted to us, we're not able yet to reproduce
> the problem in our laboratory :-( )

looks like a stack overflow or a random memory scribble to me.
Alternatively the stacktrace is entirely garbled, also a possibility.
I assume you checked there were no other external modules involved?
Also can the user use a much later version of the kernel (which has
areca merged and can enable lockdep debugging)?

