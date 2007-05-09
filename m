Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbXEIMAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbXEIMAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbXEIL7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:59:34 -0400
Received: from ozlabs.org ([203.10.76.45]:40730 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710AbXEIL7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:59:32 -0400
Subject: Re: [patch 2/9] lguest: the guest code
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org, ak@suse.de,
       jeremy@goop.org
In-Reply-To: <84144f020705090316o5e3b6d89r74638ec8e4d396d4@mail.gmail.com>
References: <200705090951.l499pYBV020391@shell0.pdx.osdl.net>
	 <84144f020705090316o5e3b6d89r74638ec8e4d396d4@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 09 May 2007 21:59:17 +1000
Message-Id: <1178711957.7286.87.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 13:16 +0300, Pekka Enberg wrote:
> Hi Rusty,
> 
> On 5/9/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> > +static void add_lguest_device(unsigned int index)
> > +{
> > +       struct lguest_device *new;
> > +
> > +       lguest_devices[index].status |= LGUEST_DEVICE_S_ACKNOWLEDGE;
> > +       new = kmalloc(sizeof(struct lguest_device), GFP_KERNEL);
> > +       if (!new) {
> > +               printk(KERN_EMERG "Cannot allocate lguest device %u\n", index);
> > +               lguest_devices[index].status |= LGUEST_DEVICE_S_FAILED;
> 
> [snip]
> 
> Any reason why we don't return an error here?

Hi Pekka,

	Hmm, where would the error go?

A little confused,
Rusty.


