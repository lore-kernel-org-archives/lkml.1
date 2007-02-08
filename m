Return-Path: <linux-kernel-owner+w=401wt.eu-S1423181AbXBHJQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423181AbXBHJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 04:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423184AbXBHJQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 04:16:28 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:53015 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423181AbXBHJQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 04:16:26 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.20 BUG: soft lockup detected on CPU#0!
Date: Thu, 8 Feb 2007 10:16:21 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lukasz Trabinski <lukasz@wsisiz.edu.pl>, linux-kernel@vger.kernel.org,
       Bartlomiej Solarz-Niesluchowski <solarz@wsisiz.edu.pl>,
       Thomas Gleixner <tglx@linutronix.de>
References: <Pine.LNX.4.64.0702080000060.13077@oceanic.wsisiz.edu.pl> <20070207204745.a2640c43.akpm@linux-foundation.org> <20070208080644.GA14579@elte.hu>
In-Reply-To: <20070208080644.GA14579@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702081016.21124.dada1@cosmosbay.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 February 2007 09:06, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> > The softlock detector has a long history of false positives and
> > precious few true positives, in my experience.
>
> hm, not so the latest & lamest in my experience. The commit that made it
> quite robust was 6687a97d4041f996f725902d2990e5de6ef5cbe5, as of March
> 2006, and first showed up in 2.6.17. (OTOH, since the merge of lockdep
> the main source of soft lockups in the field has been quite severely
> reduced. Nevertheless it's still good to have it around, occasionally
> there happen other types of soft lockups too, in open-coded loops, etc.)

This reminds me the current problem in close_files()
 code, where we trigger soft lockup quite regularly.

Is there any chance/interest we can solve the issue Andrew had with this 
patch ?

http://lkml.org/lkml/2006/5/2/273

Thank you
Eric


