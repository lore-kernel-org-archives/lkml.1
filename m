Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZLARyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZLARyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZLARyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:54:07 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:50002 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbZLARyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:54:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Te14ZlmHZn64+fM9hP9cscNp03fIkvJqjxtJyELjTjGd+FWDthMhqqSty9nenTetFX
         klZsOcv3HIck9BXMYMM+h/Fhpl4TxM02gJUdlQzi/I3NIUk7cxuag+aVKl+gtBKyIQQM
         NzgFEo6cCUXx4LQb/kyTgzlWh7uUEt2zmeKgQ=
Date: Tue, 1 Dec 2009 09:54:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
       Jon Smirl <jonsmirl@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
       j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
       superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
Message-ID: <20091201175400.GA19259@core.coreip.homeip.net>
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com> <1259682428.18599.10.camel@maxim-laptop> <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com> <4B154C54.5090906@redhat.com> <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com> <4B155288.1060509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B155288.1060509@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 03:29:44PM -0200, Mauro Carvalho Chehab wrote:
> 
> For sure we need to add an EVIOSETPROTO ioctl to allow the driver 
> to change the protocol in runtime.
> 

Mauro,

I think this kind of confuguration belongs to lirc device space,
not input/evdev. This is the same as protocol selection for psmouse
module: while it is normally auto-detected we have sysfs attribute to
force one or another and it is tied to serio device, not input
device.

-- 
Dmitry
