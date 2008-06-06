Return-Path: <linux-kernel-owner+w=401wt.eu-S1764069AbYFFGmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764069AbYFFGmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYFFGmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:42:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbYFFGmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:42:13 -0400
Date: Thu, 5 Jun 2008 23:41:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [WARNING] local_bh_enable with irqs disabled:
Message-Id: <20080605234136.189895a5.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806060751240.14536@axis700.grange>
References: <Pine.LNX.4.64.0806031529520.21106@axis700.grange>
	<20080605223917.0a02804d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806060751240.14536@axis700.grange>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 08:11:23 +0200 (CEST) Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> > Which kernel version are you running?
> 
> Sorry, this was a 2.6.26-rc3 based kernel with the gpio-sysfs patch from 
> David, e.g., http://marc.info/?l=linux-kernel&m=121107105300923&w=2,
> which introduces a call to device_unregister via gpiochip_unexport(chip); 
> in gpiochip_remove. 

OK, thanks.

That's quite buggy and would have generated so many runtime warnings in
a "developer" setup (rofl) that I look at Documentation/SubmitChecklist
and just weep.

I'll drop it.
