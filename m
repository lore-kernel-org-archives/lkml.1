Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZF1OWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZF1OWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZF1OWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:22:12 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:53799 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbZF1OWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=e52CaOAGNT6XYHJVobjk2sAlhT67eUhFrZk6fpcsjcqwmGE8W9wLwNPa0+UBR9eWHi
         tAqDfAbUCs4v0LpyuaFZ7sGlzTq8c03WwQniUFYmOXGaMub3zju9qA0E01yqM97Bb1xs
         UGXTXTmuOBnBTjZBR8scjK/fLMvv5O8VeFi60=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Sun, 28 Jun 2009 16:22:09 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Alberto Gonzalez <alberto6674@gmail.com>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <200906281437.00329.info@gnebu.es> <ac3eb2510906280549w75b4da79i1f38888a9be56c4e@mail.gmail.com>
In-Reply-To: <ac3eb2510906280549w75b4da79i1f38888a9be56c4e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906281622.10072.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 June 2009 14:49:52 Kay Sievers wrote:
> On Sun, Jun 28, 2009 at 14:37, Alberto Gonzalez<alberto6674@gmail.com> 
wrote:
> > This is what I got wen the problem finally came back (it happens
> > randomly, this time I triggered it by running glxgears, but it can happen
> > for other reasons and none of them triggers it automatically):
> >
> > KERNEL[1246192153.094553] change  
> > /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
> >
> > UDEV  [1246192153.178593] change  
> > /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
> >
> > So just an endless loop of the same message again and again.
>
> If you see this loop and kill the udev daemon, the UDEV events will
> stop. But do the KERNEL events continue, or do all events stop? This
> should tell us if some udev rules trigger something here, or if it is
> a loop in the kernel.

When I kill udevd, the KERNEL messages continue.

>
> Kay

