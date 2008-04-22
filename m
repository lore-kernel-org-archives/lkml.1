Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbYDVVdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbYDVVdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbYDVVd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:33:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbYDVVd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:33:28 -0400
Date: Tue, 22 Apr 2008 14:32:53 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, gregkh@suse.de, penberg@cs.helsinki.fi,
       zaitcev@redhat.com
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Message-Id: <20080422143253.20a8a410.zaitcev@redhat.com>
In-Reply-To: <20080422134034.GF7311@elte.hu>
References: <200804212310.41729.elendil@planet.nl>
	<20080422134034.GF7311@elte.hu>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008 15:40:34 +0200, Ingo Molnar <mingo@elte.hu> wrote:

> Cc:-ing USB folks as the kmem_cache_destroy() comes from 
> drivers/usb/mon/mon_text.c.

Thanks, Ingo, I'll look at it right away. It's difficult to
believe that usbmon would do something so stupid but stranger
things happened. Actually, I used an explicit SLAB cache and
not kmalloc specifically because SLAB catched this condition.
It would be strange if SLAB didn't and SLUB started catching it.
Anyway we'll see soon enough.

-- Pete
