Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbZHEPgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbZHEPgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbZHEPgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:36:04 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48527 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbZHEPgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:36:03 -0400
Subject: Re: [PATCH]bluetooth: rfcomm_init bug fix
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: David Miller <davem@davemloft.net>, oliver@hartkopp.net,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da0908042216u16037395k96cce0746baa504e@mail.gmail.com>
References: <20090803.132924.151782729.davem@davemloft.net>
	 <1249343666.3094.12.camel@localhost.localdomain>
	 <20090803.191916.75688176.davem@davemloft.net>
	 <20090803.211136.00343745.davem@davemloft.net>
	 <1249405306.3094.18.camel@localhost.localdomain>
	 <a8e1da0908042216u16037395k96cce0746baa504e@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 08:35:55 -0700
Message-Id: <1249486555.3094.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> >> >> do you mind at least waiting for an ACK from my side. I haven't even
> >> >> looked at the final patch.
> >> >
> >> > Sure, I haven't pushed it out yet, so now's your chance :)
> >>
> >> Grumble, I accidently pushed my net-2.6 queue out before you
> >> had a chance to reply, sorry :-(
> >
> > not a big deal. Just have to send a cleanup patch. The patch itself is
> > fine, but from a style perspective it is different than everything else
> > in the Bluetooth subsystem and I would have liked to fix that before
> > pushing it. I wait with that for 2.6.32 since it is not important.
> 
> Marcel, could you publish the bluetooth subsystem coding style
> somewhere? People including me are confused about it. I remembered I
> asked it from you, but it is still not very clear for me.

it is kernel coding style like everything else, but some variable naming
should be consistent. And that is nothing that is published, that is
something that has been done since Max wrote it. Check the rest of the
code.

> > The other Dave, please send patches to linux-bluetooth only and lets
> > follow the normal path to get them merged into Linus' tree. Skipping
> > bluetooth-2.6 is not an option. You have to use the same process than
> > everybody else.
> 
> Why linux-bluetooth only? IMHO there could be more people to comment
> and review  if I send patches to both lkml and subsystem mailing list.

Lets me make this perfectly clear here. Bluetooth patches are sent to
the linux-bluetooth mailing list. There is no need to send them to
netdev and/or LKML at the same time. Stop this cross-posting. They don't
get more review there anyway. I take care of sending them for net-2.6
inclusion if I feel that they are appropriate.

Regards

Marcel


