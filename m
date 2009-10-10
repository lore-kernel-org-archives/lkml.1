Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbZJJJy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbZJJJy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 05:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbZJJJy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 05:54:58 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:43593 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457AbZJJJy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 05:54:57 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
Date: Sat, 10 Oct 2009 11:55:47 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Josua Dietze <digidietze@draisberghof.de>, Greg KH <greg@kroah.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Hugh Blemings <hugh@blemings.org>
References: <1255134315.2139.8.camel@pasglop> <4AD03A03.5050702@draisberghof.de> <1255160461.3387.4.camel@pasglop>
In-Reply-To: <1255160461.3387.4.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910101155.48394.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 10. Oktober 2009 09:41:01 schrieb Benjamin Herrenschmidt:
> suspend is a good candidate yeah, autosuspend might be causing something
> like that, I'll see what I can find. I didn't spot an obvious change to
> the USB suspend policy between those two kernels, but it could be
> trigged by one of the numerous changes that went into usb-serial.

Then you can simply test this hunch by switching it off. If that helps
please recompile with CONFIG_USB_DEBUG enabled?

But I don't understand why the stable series is affected. Autosuspend
patches didn't go into it, did they Greg?

	Regards
		Oliver

