Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbZFWPbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbZFWPbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758596AbZFWP3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:29:54 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:56568 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZFWP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HliHEX6cxrOKVgaFe0SKVcNXIuLjBgpa7EiwzVpVmmniiG7hJpdB59uEx9Ekw3aTSN
         sPRRGdO+R/kZJK2It5BZEAzBvgOqE0jY0bvsBwgWjs0KNyf0RGxX+YyoM78zc9bJr2nK
         QBLPNNbZu9JZP4cRXYMiRtWhs1CWG1IjzlYpQ=
MIME-Version: 1.0
In-Reply-To: <20090623144221.GA29593@suse.de>
References: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com>
	 <20090623144221.GA29593@suse.de>
Date: Tue, 23 Jun 2009 23:29:50 +0800
Message-ID: <b6a2187b0906230829k308cb875r7362f184bccb1d6d@mail.gmail.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 10:42 PM, Greg KH<gregkh@suse.de> wrote:
> On Tue, Jun 23, 2009 at 01:11:51PM +0800, Jeff Chua wrote:
>> commit cc71329b3b89b4a5be849b617f2c4f151f0b9213 moved USB_DEVICEFS to
>> be embedded and marked it as depreciated. Can this be reverted? This
>> breaks vmware and those systems not using udev.

> vmware now works properly with this fix, and has for over a year or so.

vmware is working, but can't detect USB devices.

> What distro does not use udev or mdev or something like it already and
> also does not use an updated libusb?
> We need some specifics here please.

I'm not using it and have been fine without it all these while, so
don't see any gain moving to udev or perhaps it's time to consider ...

Thanks,
Jeff.
