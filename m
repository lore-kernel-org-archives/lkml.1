Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZGHLUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZGHLUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZGHLUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:20:08 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:33606 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbZGHLUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:20:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hSFOoUOoYICTi3JqCgvPG5YMWoDfQYzonJ3Ho8XiokDrC8lexN8IvqZOceV6Q/loum
         C+9eITqvZWxxBtVOqgj8YRjlkfdjPgxzPxVMFNmsvPd12II859Wk7gvbIIX1wTr607hG
         shNjl6mVo76AMGoTXzVdZswzqV6YW+Bx6T7vk=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510907080403h14e5597eu3dee309456eab17e@mail.gmail.com>
References: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com>
	 <20090623144221.GA29593@suse.de>
	 <b6a2187b0906230829k308cb875r7362f184bccb1d6d@mail.gmail.com>
	 <20090623153928.GA32604@suse.de>
	 <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com>
	 <ac3eb2510907080403h14e5597eu3dee309456eab17e@mail.gmail.com>
Date: Wed, 8 Jul 2009 21:20:04 +1000
Message-ID: <21d7e9970907080420h41375e36q1efacb9f3555b9de@mail.gmail.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
From: Dave Airlie <airlied@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Dave Jones <davej@redhat.com>, Peter Jones <pjones@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 9:03 PM, Kay Sievers<kay.sievers@vrfy.org> wrote:
> On Wed, Jul 8, 2009 at 12:54, Dave Airlie<airlied@gmail.com> wrote:
>
>> Okay can we revert this for a better reason? it seems to have unhidden a race
>> condition on booting some of my machines. I've booted some other machines
>> with the same USB disk and the same kernel fine.
>
> Are you sure? USBFS is for userspace USB drivers, booting from
> usb-storage devices should be fully handled by the kernel.
>

Yes, changing just this option means the difference between a bootable
and stuck in initrd system. maybe Peter knows if our initrd does something
otherwise I suspect we have a race that usbfs was hiding.

Dave.
