Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbYLBQ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbYLBQ6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYLBQ6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:58:31 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:3373 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbYLBQ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:58:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAF/4NEnCTsYx/2dsb2JhbACBbdB1gn8
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
Date: Tue, 2 Dec 2008 17:58:35 +0100
User-Agent: KMail/1.9.9
Cc: Hans Verkuil <hverkuil@xs4all.nl>, video4linux-list@redhat.com,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source-bounces@linux.davincidsp.com
References: <200812011246.08885.hverkuil@xs4all.nl> <200812011524.43499.laurent.pinchart@skynet.be> <20081201130643.661f5743@pedra.chehab.org>
In-Reply-To: <20081201130643.661f5743@pedra.chehab.org>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021758.35503.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Monday 01 December 2008, Mauro Carvalho Chehab wrote:
> Hi Hans,
>
> On Mon, 1 Dec 2008 15:24:43 +0100
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
[snip]

> > In a few months time (probably even earlier) the v4l2_device structure
> > will be reworked (and possible renamed).
>
> Hmm... why? it would be better to try to have the KABI changes for it at
> the same kernel release if possible.

Because Hans is working on more changes.

> > I'm fine with it going to linux-next now if
> > we agree on the following.
> >
> > - We should only advocate v4l2_device usage for subdevices-aware video
> > devices. Porting all drivers to v4l2_device is currently pointless and
> > will only make future transitions more difficult.
>
> This makes sense to me.
>
> > - v4l2_device should be marked as experimental. I don't want to hear any
> > API/ABI breakage argument in a few months time when the framework will
> > evolve.
>
> Are you meaning marking this as experimental at Kconfig? This seems too
> complex, since we'll need to test for some var on every driver that were
> converted, providing two KABI options for each converted driver (the legacy
> and the v4l2_device way). This doesn't seem to be a good idea, since will
> add a lot of extra complexity to debug bugs.

Not at the Kconfig level, just in the documentation (and possible headers).

This is a work in progress. Hans wants the changes to go mainline to get 
broader testing, which is a valid reason, but I'd like to make sure people 
understand that more changes are coming.

Best regards,

Laurent Pinchart
