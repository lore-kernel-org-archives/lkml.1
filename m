Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbYFNSwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbYFNSwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 14:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYFNSwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 14:52:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:62241 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYFNSwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 14:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lOTf+2PrqWFSNt26rnetPq0lcQamz5X6zZ2/2DZmOUksBuWQsZKGvidT9MqrhNLw0E
         GJ8jWvDLFp9NORTg07x1bD2F60HTSk1U3n+hHB957uqWW/hP793cyhLO4XF+ySw/t/SM
         6UwHo8QBlhEvSOXDPIdzcvAqiIlV9EWQ7ccPQ=
Date: Sat, 14 Jun 2008 20:51:07 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: implement flush_work()
Message-ID: <20080614185107.GA2470@ami.dom.local>
References: <20080613142801.GA9165@tv-sign.ru> <20080614091339.GA2466@ami.dom.local> <20080614135951.GA4502@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614135951.GA4502@tv-sign.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 05:59:51PM +0400, Oleg Nesterov wrote:
> On 06/14, Jarek Poplawski wrote:
...
> > Another question is if schedule_on_each_cpu() is really such a good
> > example here: it seems these "xxx && yyy" examples could be faster,
> > but I've lost track of this earlier thread.
> 
> schedule_on_each_cpu() can't use cancel_ + ->func(), the code should
> be executed on the remote CPU.

???
Actually I meant this "xxx && yyy" schedule_on_each_cpu():

http://marc.info/?l=linux-kernel&m=121329259203187&w=2

Regards,
Jarek P.
