Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbZLEEhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbZLEEhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 23:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbZLEEhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 23:37:42 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:21049 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701AbZLEEhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 23:37:41 -0500
Date: Fri, 4 Dec 2009 21:37:47 -0700
From: Alex Chiang <achiang@hp.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci: Make pci_dev struct point to NULL.
Message-ID: <20091205043747.GB10777@ldl.fc.hp.com>
References: <b9df5fa10912040835k3e23702o8700d2d8ad2349a4@mail.gmail.com> <20091204202709.GA32347@ldl.fc.hp.com> <b9df5fa10912041753n27e60020x2dd41eb50f4608ff@mail.gmail.com> <20091205043635.GA10777@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091205043635.GA10777@ldl.fc.hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Chiang <achiang@hp.com>:
> * Rakib Mullick <rakib.mullick@gmail.com>:
> > On 12/5/09, Alex Chiang <achiang@hp.com> wrote:
> > > * Rakib Mullick <rakib.mullick@gmail.com>:
> > >
> > > This is from Linus's latest tree:
> > >
> > >   974
> > >   975         if (slot->flags & SLOT_ENABLED)
> > >   976                 goto err_exit;
> > 
> > I'm talking about this line. From here we can hit 'goto err_exit' without
> > using pci_get_slot.
> 
> Right, so what's the problem? If the slot is not enabled, we goto
> err_exit and return, never touching dev.
 
Whoops, of course I meant if the slot is already enabled, then we
return early.

/ac

