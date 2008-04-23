Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYDWFV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYDWFV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 01:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYDWFVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 01:21:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52028 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYDWFVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 01:21:45 -0400
Date: Wed, 23 Apr 2008 08:21:42 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Pete Zaitcev <zaitcev@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de,
       clameter@sgi.com
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
In-Reply-To: <20080422143253.20a8a410.zaitcev@redhat.com>
Message-ID: <Pine.LNX.4.64.0804230819100.24771@sbz-30.cs.Helsinki.FI>
References: <200804212310.41729.elendil@planet.nl> <20080422134034.GF7311@elte.hu>
 <20080422143253.20a8a410.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On Tue, 22 Apr 2008 15:40:34 +0200, Ingo Molnar <mingo@elte.hu> wrote:
> > Cc:-ing USB folks as the kmem_cache_destroy() comes from 
> > drivers/usb/mon/mon_text.c.

On Tue, 22 Apr 2008, Pete Zaitcev wrote:
> Thanks, Ingo, I'll look at it right away. It's difficult to
> believe that usbmon would do something so stupid but stranger
> things happened. Actually, I used an explicit SLAB cache and
> not kmalloc specifically because SLAB catched this condition.
> It would be strange if SLAB didn't and SLUB started catching it.
> Anyway we'll see soon enough.

SLAB checks this too so you should get a similar error.

		Pekka
