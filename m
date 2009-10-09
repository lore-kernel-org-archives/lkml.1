Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbZJIMQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbZJIMQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 08:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbZJIMQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 08:16:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760535AbZJIMQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 08:16:11 -0400
Date: Fri, 9 Oct 2009 14:15:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       linux-cris-kernel <linux-cris-kernel@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CIRS: turn local_save_flags() + local_irq_disable()into
 local_irq_save()
In-Reply-To: <20091009105215.GC24141@axis.com>
Message-ID: <alpine.LSU.2.00.0910091414540.19284@wotan.suse.de>
References: <alpine.LSU.2.00.0910091138500.19284@wotan.suse.de> <20091009105215.GC24141@axis.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, Jesper Nilsson wrote:

> > This is a followup to my patches that fixed this all over the tree quite some
> > time ago. This one went unnoticed for some reason.
> > 
> > TLB handling for CRIS contains local_irq_disable() after local_save_flags().
> > Turn this into local_irq_save().
> 
> Thanks, that looks good.

I will then add

	Acked-by: Jesper Nilsson <Jesper.Nilsson@axis.com>

to it if you don't mind (the same for the old debug stuff removal).

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
