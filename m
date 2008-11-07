Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYKGJUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYKGJUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYKGJUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:20:14 -0500
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:38762 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYKGJUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:20:13 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Scheduler RR, first time slice wrong?
Date: Fri, 7 Nov 2008 10:19:57 +0100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Andreas Huber <andreas.huber@keymile.com>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <1225956167.4472.27.camel@chber1-10446x.ch.keymile.net> <20081106074449.GC8459@elte.hu> <1225961212.7803.4190.camel@twins>
In-Reply-To: <1225961212.7803.4190.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811071020.06422.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thursday 06 November 2008, Peter Zijlstra wrote:
> Currently we inherit the RR time-slice from our parent. In case that is
> init we inherit the 1s value set by default, in case its an already
> running RR task, we inherit whatever is left.
> 
> Fix both these by resetting the time-slice on fork.

I remember that this MIGHT be on purpose to mitigate fork bombs.

Behaviour was, that you could starve others, if you fork, 
do little or no work and fork again before your timeslice is over.

But I'm not sure this applies here...


Best Regards

Ingo Oeser
