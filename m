Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbYJIEGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbYJIEGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYJIEFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:05:51 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:36673 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYJIEFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:05:50 -0400
Date: Wed, 8 Oct 2008 22:05:49 -0600
From: Alex Chiang <achiang@hp.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 11/15] PCI: rpaphp: kmalloc/kfree slot->name directly
Message-ID: <20081009040549.GB4668@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20081003230125.9989.31145.stgit@bob.kio> <20081003231823.9989.50968.stgit@bob.kio> <84144f020810052344x5b90c22fjd7b984e1d2dddde2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020810052344x5b90c22fjd7b984e1d2dddde2@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg <penberg@cs.helsinki.fi>:
> On Sat, Oct 4, 2008 at 2:18 AM, Alex Chiang <achiang@hp.com> wrote:
> > @@ -63,10 +63,9 @@ struct slot *alloc_slot_struct(struct device_node *dn,
> >                                           GFP_KERNEL);
> >        if (!slot->hotplug_slot->info)
> >                goto error_hpslot;
> > -       slot->hotplug_slot->name = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
> > -       if (!slot->hotplug_slot->name)
> > +       slot->name = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
> > +       if (!slot->name)
> >                goto error_info;
> > -       slot->name = slot->hotplug_slot->name;
> >        strcpy(slot->name, drc_name);
> 
> Minor nit: you could use kstrdup() here.

Good call, I've made a change, thanks.

/ac

