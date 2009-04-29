Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZD2TAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZD2TAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZD2S7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:59:54 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:57512 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZD2S7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:59:53 -0400
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> 
	<20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 29 Apr 2009 20:59:31 +0200
Message-ID: <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 20:17, Mike Frysinger <vapier.adi@gmail.com> wrote:

>>> looks like update-usbids.sh was forgotten from EXTRA_DIST in
>>> Makefile.am so the released tarball doesnt have the script ;(

> np, i'll send patches for both

Ah missed that, sorry. Sounds good if you add it to the tarball, but
please don't add it to "make install", as packages should not ship
scripts which change the installed package content, unless it's a
config file.

Thanks,
Kay
