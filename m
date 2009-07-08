Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZGHLET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZGHLET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZGHLEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:04:12 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:33750 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZGHLEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:04:11 -0400
MIME-Version: 1.0
In-Reply-To: <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com>
References: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com> 
	<20090623144221.GA29593@suse.de> <b6a2187b0906230829k308cb875r7362f184bccb1d6d@mail.gmail.com> 
	<20090623153928.GA32604@suse.de> <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 8 Jul 2009 13:03:55 +0200
Message-ID: <ac3eb2510907080403h14e5597eu3dee309456eab17e@mail.gmail.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Dave Jones <davej@redhat.com>, Peter Jones <pjones@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 12:54, Dave Airlie<airlied@gmail.com> wrote:

> Okay can we revert this for a better reason? it seems to have unhidden a race
> condition on booting some of my machines. I've booted some other machines
> with the same USB disk and the same kernel fine.

Are you sure? USBFS is for userspace USB drivers, booting from
usb-storage devices should be fully handled by the kernel.

Thanks,
Kay
