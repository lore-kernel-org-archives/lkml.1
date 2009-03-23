Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZCWNxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZCWNxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZCWNxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:53:08 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:27194 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbZCWNxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:53:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEABsxx0nCTtAn/2dsb2JhbACBUM95gkCBPgY
Date: Mon, 23 Mar 2009 14:52:58 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: christian pellegrin <chripell@fsfe.org>
Cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org
Subject: Re: [PATCH] parport netmos 9845 & 9855 1P4S fixes
Message-ID: <20090323135258.GA25840@frolo.macqel>
References: <20090319181120.GA18034@frolo.macqel> <20090323085024.GA8897@frolo.macqel> <cabda6420903230621k6ba147cqb055c724777dde6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cabda6420903230621k6ba147cqb055c724777dde6b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 02:21:59PM +0100, christian pellegrin wrote:
> On Mon, Mar 23, 2009 at 9:50 AM, Philippe De Muyter <phdm@macqel.be> wrote:
> > Hello list,
> >
> 
> Hi,
> 
> > Christian, can you verify that the patch below works for your
> > netmos 9855 2P2S board ?
> 
> I compiled a kernel with this patch and I see both serial and both
> parallel ports in dmesg. I tested the serial ports and they work.

Thanks for your quick feedback.

> Unfortunately I don't have any device around to test the parallel
> ports. You know, USB killed the pport stars.

I only use parallel ports for hardware debuggers.

> 
> > Last fix of Christian Pellegrin for 9855 2P2S broke support for 9855 1P4S,
> > and works only by side-effect for the first parallel port of a 2P2S,
> 
> sorry for that, I didn't know about the 1P4S version. This is the
> reason why I changed netmos9855 entry directyl.

No problem.  I have not been affected.  I needed to fix the 9845 1P4S
support, but as I have also a computer with a 9855 1P4S, I did some
code inspection there also and found your change.

Have a nice day

Philippe
