Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbXGWUEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbXGWUEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbXGWUEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:04:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:62474 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbXGWUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:04:46 -0400
Subject: Re: [PATCH -rt] temporary WARN_ON removal
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070723195548.GA10445@elte.hu>
References: <1185124961.2573.14.camel@imap.mvista.com>
	 <20070723195548.GA10445@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 12:53:22 -0700
Message-Id: <1185220402.2573.132.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 21:55 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > These two WARN_ON calls send my system into a boot hang. They trigger 
> > over and over , some examples below.
> 
> hm, could you try to figure out why they trigger on your box and not on 
> anyone else's box? By disabling them we might be papering over a 
> potential problem.
> 

Try running with !PREEMPT_RT , that's the only time that I see those
message .. That's also why I thought it was related to timing ..

Daniel

