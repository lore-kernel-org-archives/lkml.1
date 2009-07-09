Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbZGIAnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbZGIAnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbZGIAn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:43:28 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:58556 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261AbZGIAnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YeC6ShoCbzEw3w+n/I6kXwp8QZJbXz75DqDbfqhDTnRfOg43432ufRTTunALvufJ43
         hiQcPOmsTm/gzr+NTdLnGy/zCy+FXb6vytNbLVbTgq1MzlJOGLGR5ZxLV97GW8F8OE7z
         osGeRIMydlK1hPJQ4GZ05HfDHPjzt2siYwUPk=
MIME-Version: 1.0
In-Reply-To: <21d7e9970907081423v6d3830eey227f3d54b10382a6@mail.gmail.com>
References: <20090623144221.GA29593@suse.de>
	 <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com>
	 <4A54A4A6.2060100@redhat.com> <4A54A538.3080407@redhat.com>
	 <20090708140419.GA20418@suse.de> <4A54A938.5030807@redhat.com>
	 <20090708145625.GA20690@suse.de> <4A54B5C2.9000908@redhat.com>
	 <20090708154758.GB20979@suse.de>
	 <21d7e9970907081423v6d3830eey227f3d54b10382a6@mail.gmail.com>
Date: Thu, 9 Jul 2009 08:43:06 +0800
Message-ID: <b6a2187b0907081743w61102ff4u75d15c2f3cae26d@mail.gmail.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Peter Jones <pjones@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 5:23 AM, Dave Airlie<airlied@gmail.com> wrote:

> So I don't think CONFIG_EMBEDDED is correct at least at this point.

Without CONFIG_EMBEDDED ...
  CONFIG_NAMESPACES=y

With CONFIG_EMBEDDED=y ...
  # CONFIG_NAMESPACES is not set
  CONFIG_VMSPLIT_3G=y

I can't find a place to change these using menuconfig when EMBEDDED is selected.

I agree that CONFIG_EMBEDDED is not the right place to hide this
becuase it changed the behavior of more than just usbfs.

Thanks,
Jeff
