Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZCCPq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZCCPq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbZCCPqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:46:50 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:38834 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZCCPqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:46:49 -0500
Date: Tue, 3 Mar 2009 16:46:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Add to_delayed_work macro
Message-ID: <20090303164629.10d80a82@hyperion.delvare>
In-Reply-To: <49AD4DA0.6040400@s5r6.in-berlin.de>
References: <20090303083440.57df68c3@hyperion.delvare>
	<20090303002952.80f1afc8.akpm@linux-foundation.org>
	<20090303102236.1ad909ad@hyperion.delvare>
	<49AD4DA0.6040400@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Mar 2009 16:32:48 +0100, Stefan Richter wrote:
> Jean Delvare wrote:
> > On Tue, 3 Mar 2009 00:29:52 -0800, Andrew Morton wrote:
> >> On Tue, 3 Mar 2009 08:34:40 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> >> 
> >> > +#define to_delayed_work(_work)	container_of(_work, struct delayed_work, work)
> >> 
> >> As this is specifically designed to operate on a `struct work*', as
> >> opposed to "any struct which has a field called `work'", we can get
> >> additional type-safety by putting a C interface around it.
> > 
> > This is what I wanted to do in the first place, but then I noticed that
> > _all_ such wrappers around container_of are implemented as macros
> > rather than inline functions.
> 
> /Almost/ all.
> 
> http://lxr.linux.no/linux+v2.6.28/drivers/firewire/fw-device.h#L73

Ah, I missed that one because it's not named to_<something>, sorry.

> > So I decided to follow the crowd. Any idea why it is so?
> 
> Merely old habits.


-- 
Jean Delvare
