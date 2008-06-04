Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbYFDTCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbYFDTCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760060AbYFDTCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:02:40 -0400
Received: from hs-out-0708.google.com ([64.233.178.251]:23029 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759534AbYFDTCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=px+e0YtnK4dPzYU1U/m8+uCP3YZ5Hep7oDQPmRPcECbR0x6MvvsuLdkEOU3TAg5tr2
         goMOZtug0wOzsITUMKmTjBO1dswyhn8OFckvY3QQaNPAGQxRFK6KMu5QFGANON/Drv3r
         RMnKhcPnXGNTMhyyLL8ViGiWqL7elufy8ZY7g=
Message-ID: <cd73a99e0806041202v592c41e1ya3c9fa51918efb0f@mail.gmail.com>
Date: Wed, 4 Jun 2008 21:02:30 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: AT91SAM9/CAP9 watchdog driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>, wim@iguana.be,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080604192458.02f76022@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
	 <20080603142316.c53b32b2.akpm@linux-foundation.org>
	 <cd73a99e0806040031s13e6b4a5ndc5fb3d931e1945f@mail.gmail.com>
	 <20080604123642.51449a04@core>
	 <cd73a99e0806041136o2a9ee520q28752af9b6290644@mail.gmail.com>
	 <20080604192458.02f76022@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Alan ,

> Every other watchdog behaves as follows
>
> - If you specify a bogus value it doesn't load
> - If you specify no value you get a valid default
> - If you specify a valid value you get that
>
> I don't believe yours should be different.

I don't think any other in-kernel watchdog driver has to deal with
write-once hardware.  On these processors once the watchdog register
is programmed, it cannot be disabled or re-programmed.
If the above behaviour is required, then we might aswell remove the
ioctl(WDIOC_SETTIMEOUT) interface for this driver since if the user
wants anything other than the default timeout they would need to pass
it via the kernel command-line or module parameters.


Regards,
  Andrew Victor
