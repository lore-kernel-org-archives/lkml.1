Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbXHRTcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbXHRTcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 15:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbXHRTc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 15:32:27 -0400
Received: from mx1.ciphirelabs.net ([217.72.114.64]:44939 "EHLO
	mx.dmz.ciphirelabs.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbXHRTc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 15:32:27 -0400
From: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel events? [u]
Date: Sat, 18 Aug 2007 21:32:11 +0200
User-Agent: KMail/1.9.6
References: <Pine.LNX.4.44L0.0708171306360.2546-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708171306360.2546-100000@iolanthe.rowland.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708182132.11336.aj@ciphirelabs.com>
X-Ciphire-Security: plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 17. August 2007 schrieben Sie:
> On Fri, 17 Aug 2007, Andreas Jellinghaus [c] wrote:
> > I need some kernel event that has both DEVICE and MODALIAS set.
> > up to including kernel 2.6.21 this seems to come from
> > drivers/usb/core/driver.c if I read the code correctly, and then
> > it was removed.
> >
> > udevmonitor --kernel --environment shows one event with both on 2.6.21
> > plain, but not on 2.6.22 plain.
>
> Does this patch improve matters?

yes, thanks, it does. can you add PRODUCT as well?
remembered too late that my scripts at least use it too.
but that one is no big issue, MODALIAS has the same information
so I could use that information. but other people might use it.

Regards, Andreas
