Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYLBRBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYLBRBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYLBRBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:01:33 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:8041 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbYLBRBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:01:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAF/4NEnCTsYx/2dsb2JhbACBbdB1gn8
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
Date: Tue, 2 Dec 2008 18:01:38 +0100
User-Agent: KMail/1.9.9
Cc: video4linux-list@redhat.com,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source-bounces@linux.davincidsp.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200812011246.08885.hverkuil@xs4all.nl> <200812011524.43499.laurent.pinchart@skynet.be> <200812011547.27644.hverkuil@xs4all.nl>
In-Reply-To: <200812011547.27644.hverkuil@xs4all.nl>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021801.39073.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Monday 01 December 2008, Hans Verkuil wrote:
> On Monday 01 December 2008 15:24:43 Laurent Pinchart wrote:
[snip]
> > In a few months time (probably even earlier) the v4l2_device
> > structure will be reworked (and possible renamed). I'm fine with it
> > going to linux-next now if we agree on the following.
> >
> > - We should only advocate v4l2_device usage for subdevices-aware
> > video devices. Porting all drivers to v4l2_device is currently
> > pointless and will only make future transitions more difficult.
>
> Agreed. For now it is only relevant for drivers that use subdevices.
>
> > - v4l2_device should be marked as experimental. I don't want to hear
> > any API/ABI breakage argument in a few months time when the framework
> > will evolve.
>
> Am I overlooking something? This API is a kernel API, not a public API.
> Hence if I (or anyone else for that matter) make future changes then it
> is my responsibility to adapt all other drivers that are affected at
> the same time. I don't see how any of this could break compatibility.
> Except for out-of-kernel drivers, of course. But that's the risk that
> they always run.

You're right. It might be useful to state that the API is a work in progress 
in the documentation, but I'll let you decide on that.

> Marking this API as experimental seems pointless to me. It either works
> and so is available for use or it doesn't and then it is a plain old
> bug that needs to be fixed. I also know already that there will be
> changes as e.g. sensors require a new ops category and v4l2_device
> might need a notifier callback as well. However, I'm not going to
> implement that until there is also a driver that uses it (adding
> functionality to an internal API just because it might be needed in the
> future is a really bad idea).

Best regards,

Laurent Pinchart
