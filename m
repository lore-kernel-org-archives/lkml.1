Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab0BLHfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 02:35:39 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:38688 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab0BLHfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 02:35:37 -0500
From: Oliver Neukum <oliver@neukum.org>
To: David Fries <david@fries.net>
Subject: Re: usbhid control queue full, due to stuck control request
Date: Fri, 12 Feb 2010 08:35:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, USB list <linux-usb@vger.kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100206172051.GA22311@spacedout.fries.net> <alpine.LRH.2.00.1002111617290.16183@twin.jikos.cz> <20100212004910.GD22311@spacedout.fries.net>
In-Reply-To: <20100212004910.GD22311@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002120835.36908.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 12. Februar 2010 01:49:10 schrieb David Fries:
> Oliver Neukum, this is based on your patch, do you agree with the
> changes?

I do agree.

> One possible problem with this fix is it drops the stalled URB
> transfer.  That might pose a problem for one shot messages, possibly
> hid_ctrl and hid_irq_out could resubmit the same urb when -ECONNRESET
> is received, assuming the message content wasn't the reason it
> timedout in the first place.

That is a big assumption. Realistically, if the hardware needs over 5s
to answer the hardware is buggy. We are working around that. It is best
to get not too fancy, unless testing shows that we need to.

	Regards
		Oliver
