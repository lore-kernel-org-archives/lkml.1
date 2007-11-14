Return-Path: <linux-kernel-owner+w=401wt.eu-S1761139AbXKNTUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbXKNTUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXKNTUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:20:40 -0500
Received: from twin.jikos.cz ([213.151.79.26]:60813 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXKNTUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:20:39 -0500
Date: Wed, 14 Nov 2007 20:19:38 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
In-Reply-To: <1195065493.2168.31.camel@lov.site>
Message-ID: <Pine.LNX.4.64.0711142018390.15844@twin.jikos.cz>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> 
 <a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com> 
 <20071113223802.2ace1a61.akpm@linux-foundation.org> 
 <a8e1da0711132247jd440f8dgc9ac0442e90f2c34@mail.gmail.com> 
 <20071114004129.783fb98b.akpm@linux-foundation.org> 
 <a8e1da0711140136i1e441371j306e7b2888de104e@mail.gmail.com> 
 <20071114165906.GB13889@kroah.com> <1195065493.2168.31.camel@lov.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Kay Sievers wrote:

> Could it be an init-order problem, where something tries to use the
> block subsystem? Before it is initialized with:
>   block/genhd.c :: subsys_initcall(genhd_device_init);
> If that's the case, we have an old bug that nobody noticed with static 
> structures, which are zeroed that time, but definitely not properly 
> initialized. I'll try to build loop non-modular now, and see if that 
> makes the bug appear here.

Hi Kay,

my .config with which I reproduc this on 2.6.24-rc2-mm1 reliably can be 
obtained from http://www.jikos.cz/jikos/junk/.config

-- 
Jiri Kosina
