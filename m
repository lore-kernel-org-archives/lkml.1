Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbZEGLvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbZEGLvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZEGLvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:51:24 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:55872 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZEGLvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X2R8BAVuoxjncR0GX13cTiBF7Rw6l066o+dtT2clat3j1qdG0wxWAnMlMEwMKyNmpl
         kb59UrRELFdnruetLZNeZMWagOI+XTkX5G1f/2bl5U7bctJeIl8wI/BwduTYl2Z7yDyd
         hdTwtAo/fCjidv1efCKuO/K4BJKUb76Cbc+Pw=
MIME-Version: 1.0
In-Reply-To: <20090506222439.GB22327@kroah.com>
References: <20090506222439.GB22327@kroah.com>
Date: Thu, 7 May 2009 19:51:23 +0800
Message-ID: <a276da400905070451j550d9a9ajcdd3ab30b03278aa@mail.gmail.com>
Subject: Re: usbutils 0.82 release
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 6:24 AM, Greg KH <greg@kroah.com> wrote:
> Here's the 0.82 release of usbutils.
>
> Many bugs with autoconf were resolved to hopefully make it easier for
> distros to find where the usb.ids file is dynamically.  Wireless USB
> device support was added, as well as other bugfixes.  The full shortlog
> is below.
>
> The tarballs can be downloaded from sf.net at:
>        https://sourceforge.net/project/showfiles.php?group_id=3581
>

Not sure if this is a real problem or not. There is a compiler warning
for gcc 4.4.0.

gcc -DHAVE_CONFIG_H -I.   -DDATADIR=\"/usr/share\"   -g -O2 -MT
lsusb-names.o -MD -MP -MF .deps/lsusb-names.Tpo -c -o lsusb-names.o
`test -f 'names.c' || echo './'`names.c
names.c: In function ‘names_init’:
names.c:803: warning: assignment makes pointer from integer without a cast


-- 
Xiaofan http://mcuee.blogspot.com
