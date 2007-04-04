Return-Path: <linux-kernel-owner+w=401wt.eu-S1030389AbXDDDqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030389AbXDDDqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 23:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992562AbXDDDqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 23:46:45 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56735 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030384AbXDDDqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 23:46:43 -0400
X-Sasl-enc: V4LXZ96VKDRr08SDtuHR8tENooQN1x9jvNCS9RCtg23L 1175658403
Date: Wed, 4 Apr 2007 00:46:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alexey Starikovskiy <aystarik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
Message-ID: <20070404034639.GB4511@khazad-dum.debian.net>
References: <460E0158.7090705@goop.org> <8f8ff01d0703310033y74421cfcl747ece1be003471@mail.gmail.com> <460F511E.2090102@goop.org> <46103DF2.30001@goop.org> <20070402023846.GC28561@khazad-dum.debian.net> <46108C52.7030301@goop.org> <20070403123431.GA24717@khazad-dum.debian.net> <46129E7D.60103@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46129E7D.60103@goop.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007, Jeremy Fitzhardinge wrote:
> Attached.  Is there some tool for decoding the DSDT?

iasl.  The documentation is the ACPI Specification.

> >> ezr:pts/1; cat /proc/acpi/ibm/thermal
> >> temperatures:   72 55 -128 65 40 -128 35 -128 51 53 -128 -128 -128 -128
> >> -128 -128
> >
> > This is a highly unusual output for thinkpads, but might be the expected one
> > for your X60, the X-series has always been a bit weird.  I'd higly suggest
> 
> How would you expect it to look?  I did some non-conclusive tests under

I would not expect a -128 on the third position.  The other two -128 are
expected, as they are the thermal sensors for the secondary battery.  There
is also one less sensor than I'd expect.

> Windows, and I'm beginning to get the feeling that there is actually a
> cooling problem with the hardware.

This must be at least the third complain I come across of a X60 which boils
the CPU.  The standard fix from Lenovo is a planar card swap (motherboard
swap).  Since this *does* mean they replace the thermal compounds, and a
full reassembly of the heat pipes, it might be that just fixing the thermal
coupling between cooling assembly and the CPU might do it.

> It doesn't seem to help.  When its failing to control cooling (temp
> creeps towards 100C while under load), its going at ~3700RPM, which is
> about what level 7 does.

Well, at least the EC is not misbehaving, then.

> What's a typical max RPM?  I'm getting the impression that there's

More than 4000rpm, in disengaged mode.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
