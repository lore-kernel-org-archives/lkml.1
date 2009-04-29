Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbZD2SW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbZD2SW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZD2SWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:22:49 -0400
Received: from kroah.org ([198.145.64.141]:51030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbZD2SWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:22:48 -0400
Date: Wed, 29 Apr 2009 11:16:57 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.30-rc3] platform_bus: remove "which platform_data?"
	confusion
Message-ID: <20090429181657.GA30078@kroah.com>
References: <200904271943.40588.david-b@pacbell.net> <20090429040810.GI23062@kroah.com> <d82e647a0904290508l1b313389qcaf41c5d10f9abcd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0904290508l1b313389qcaf41c5d10f9abcd@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 08:08:10PM +0800, Ming Lei wrote:
> 2009/4/29 Greg KH <greg@kroah.com>:
> >
> > Ming, what do you think of this?
> 
> I did not know platform_data field can be used in other bus , so please
> revert the previous patches.

So that would be the following 2 commits, right:
	ce21c7bcd796fc4f45d48781b7e85f493cc55ee5
	006f4571a15fae3a0575f2a0f9e9b63b3d1012f8
anything else I need to revert as well?

thanks,

greg k-h
