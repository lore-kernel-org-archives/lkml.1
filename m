Return-Path: <linux-kernel-owner+w=401wt.eu-S1762454AbYBFLaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762454AbYBFLaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYBFLaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:30:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58084 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbYBFLaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:30:09 -0500
Subject: Re: RT scheduler config, suggestions and questions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1202279815.19243.34.camel@lappy>
References: <47A8F328.5070107@qualcomm.com>
	 <1202279815.19243.34.camel@lappy>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 12:29:40 +0100
Message-Id: <1202297381.19243.48.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-06 at 07:36 +0100, Peter Zijlstra wrote:

> > btw I can see "watchdog" being very useful to catch hard-RT tasks that exceed the deadline.
> > But's it gotta be per thread.
> 
> It is.
> 
> > Single setting per user is not enough. Unless a use has a single RT task.
> 
> ?

Ah, its starting to make sense, you want it configurable per thread, not
process wide. Yes, I see how that is useful, just no idea how to expose
that to user-space atm.




