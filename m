Return-Path: <linux-kernel-owner+w=401wt.eu-S934717AbYEBPIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717AbYEBPIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbYEBPIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:08:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:34967 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbYEBPIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=cNvzfVbsQvv1kT/oMPxVPrSLMV6Gnj/PKidccj3Fdh6J6FBwMCnLzAGBm5dU3OGxDX4CVQ2Mr2R0lGXLU9THgNWK/gS07JbFGOR8FtU0M9I5a36/wHMz4x+TAQdTKQIZDUvsPiz44H3P0YPAo4nZFUJlPpFpyIQFYeqSWzb80WQ=
Date: Fri, 2 May 2008 17:08:08 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net
Subject: Re: Who reverted 2.6.25 - stats
Message-Id: <20080502170808.25283f01.diegocg@gmail.com>
In-Reply-To: <alpine.LNX.1.10.0805021332510.6463@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0805021332510.6463@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 2 May 2008 14:16:19 +0200 (CEST), Jan Engelhardt <jengelh@medozas.de> escribió:

> following the implied "suggestion" of David Miller to track reverts in 
> http://marc.info/?l=linux-kernel&m=120959059828048&w=2 , I stitched 
> together a short script that evaluates the commit log summary and prints 
> a overview who has the most reverts and who got reverted most. There are 
> surprisingly few revert commits -- currently, perhaps because, as he 
> says, a "reluctance to even suggest reverts".

But what exactly those numbers mean?

A big number of reverts can mean that a developer usually submits unstable
stuff. But it can also mean that a developer cares so much about stability
that he'd rather revert, fix it and try to merge it in the next development
cycle. The "bad" maintainer that submits unstable stuff may try to fix
the reported bug instead of reverting it (but he won't fix the other 
undiscovered bugs that are still there because the code was not tested
well enought)

I don't think those numbers are very useful. Even the "number of bug reports
filed against the code of a given developer" is not considered meaningful as
measurement of good programming.
