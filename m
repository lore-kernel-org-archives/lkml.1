Return-Path: <linux-kernel-owner+w=401wt.eu-S1161545AbXBHIQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161545AbXBHIQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161547AbXBHIQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:16:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:32867 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161545AbXBHIQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:16:11 -0500
Date: Thu, 8 Feb 2007 00:15:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lukasz Trabinski <lukasz@wsisiz.edu.pl>, linux-kernel@vger.kernel.org,
       Bartlomiej Solarz-Niesluchowski <solarz@wsisiz.edu.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.20 BUG: soft lockup detected on CPU#0!
Message-Id: <20070208001540.812f423a.akpm@linux-foundation.org>
In-Reply-To: <20070208080644.GA14579@elte.hu>
References: <Pine.LNX.4.64.0702080000060.13077@oceanic.wsisiz.edu.pl>
	<20070207204745.a2640c43.akpm@linux-foundation.org>
	<20070208080644.GA14579@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 09:06:44 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > The softlock detector has a long history of false positives and 
> > precious few true positives, in my experience.
> 
> hm, not so the latest & lamest in my experience. The commit that made it 
> quite robust was 6687a97d4041f996f725902d2990e5de6ef5cbe5, as of March 
> 2006, and first showed up in 2.6.17. (OTOH, since the merge of lockdep 
> the main source of soft lockups in the field has been quite severely 
> reduced. Nevertheless it's still good to have it around, occasionally 
> there happen other types of soft lockups too, in open-coded loops, etc.)
> 

So...  what caused Lukasz's lockup?
