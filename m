Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYDVOpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYDVOpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764136AbYDVOo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:44:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34248 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764130AbYDVOo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:44:27 -0400
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org
In-Reply-To: <480DF861.6000705@qumranet.com>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
	 <1208851058-8500-2-git-send-email-jens.axboe@oracle.com>
	 <480DACDD.7040108@qumranet.com> <20080422092230.GW12774@kernel.dk>
	 <20080422111403.GX12774@kernel.dk> <1208869254.7115.258.camel@twins>
	 <20080422142543.GG12774@kernel.dk>  <480DF861.6000705@qumranet.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 16:43:57 +0200
Message-Id: <1208875437.7115.271.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 17:38 +0300, Avi Kivity wrote:
> Jens Axboe wrote:
> >> Introducing this fallback will make any usage from irq disabled context
> >> deadlock prone.
> >>
> >> I rather like the current interface.
> >>     
> >
> > Hmm good point, I'll back that bit out again.
> >   
> 
> But then you need to fix all callers to handle errors.

Sure.

> Perhaps we need a new flag for failable async IPIs (or better, API).  
> I'm pretty sure no one uses s_c_f_s() from irq disabled context on x86, 
> since it will WARN_ON(irqs_disabled()).

Yeah, no current users, but that doesn't say I don't want to add new
ones ;-)

