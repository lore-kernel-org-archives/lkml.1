Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYDDGyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYDDGyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYDDGyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:54:31 -0400
Received: from nn7.de ([85.214.94.156]:50285 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbYDDGyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:54:31 -0400
Subject: Re: 2.6.25 intended change: smc:kbd_backlight vs.
	smc::kbd_backlight ?
From: Soeren Sonnenburg <kernel@nn7.de>
To: rpurdie@rpsys.net
Cc: Julien BLACHE <jb@jblache.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1207162690.9669.11.camel@localhost>
References: <1207162690.9669.11.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 04 Apr 2008 08:54:28 +0200
Message-Id: <1207292068.4511.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 20:58 +0200, Soeren Sonnenburg wrote:
> Dear all,
> 
> I am wondering whether the change from 
> 
> /sys/devices/platform/applesmc.768/leds/smc:kbd_backlight  (2.6.24) 
> /sys/devices/platform/applesmc.768/leds/smc::kbd_backlight (2.6.25)
> 
> is intentional?
> 
> I recognized that it breaks current userspace applications changing the
> keyboard background leds like pommed...

OK it looks like commit 6c152beefbf90579d21afc4f7e075b1f801f9a75 from
Richard Purdie, 'leds: Standardise LED naming scheme' introduced this
change.

Why do we need '::' instead of a single ':' (that would not have broken
things)?

Also sometimes only a single ':' seperator is used like in
corgi:green:mail but e.g. not in clevo::mail ?!

Soeren
