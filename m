Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZJGLHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZJGLHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZJGLHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:07:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44524
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856AbZJGLHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:07:01 -0400
Date: Wed, 07 Oct 2009 04:06:56 -0700 (PDT)
Message-Id: <20091007.040656.62828073.davem@davemloft.net>
To: david@fries.net
Cc: bzolnier@gmail.com, torvalds@linux-foundation.org, joao.ramos@inov.pt,
       d.stussy@yahoo.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] two ide fixes for -rc4
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091007033005.GE21612@spacedout.fries.net>
References: <alpine.LFD.2.01.0910061534040.3432@localhost.localdomain>
	<200910070246.05283.bzolnier@gmail.com>
	<20091007033005.GE21612@spacedout.fries.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Fries <david@fries.net>
Date: Tue, 6 Oct 2009 22:30:06 -0500

> On Wed, Oct 07, 2009 at 02:46:05AM +0200, Bartlomiej Zolnierkiewicz wrote:
>> The corrected version below, David please try it instead:
>> 
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Subject: [PATCH take 2] sis5513: fix PIO setup for ATAPI devices
> 
> 2.6.31 plus this patch fixed the hang on IDE initialization with the
> SIS5513.
> 
> That's with my testing mode, I'm rebuilding a kernel and will try some
> benchmarks tomorrow.  I've been testing by hibernating to disk,
> booting the test kernel with a bad root and resume partition (so if it
> worked it wouldn't modify the suspended image), then rebooting to
> resume from disk with the good kernel.  That let me more quickly
> bisect and test kernels, I just haven't ran this kernel much past the
> initialization is all.

All applied, thanks everyone.
