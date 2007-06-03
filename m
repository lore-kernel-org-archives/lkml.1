Return-Path: <linux-kernel-owner+w=401wt.eu-S1761430AbXFCMfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430AbXFCMfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 08:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbXFCMfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 08:35:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:39641 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbXFCMfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 08:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DmGgqOPg9n4qG+XyHZbkilzkPkXtcYcxML5BXJPt8Co0JZ1rWKIzwG/HaMs2r4UYlGd6G6WMYh/6gQStj93Kgr/McXP4fCOuZq3C3M1RLpYr7al3oNmLrXZl+lekAU/m/otiRlV3D6guRbApw+CHsC9m8NcGQ6yrLbxaf4FhtY0=
Message-ID: <3ae72650706030535k26f9d982t382d8fd145c4e966@mail.gmail.com>
Date: Sun, 3 Jun 2007 14:35:07 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error sending control message: Operation not permitted)
Cc: "Jiri Kosina" <jikos@jikos.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706030749580.3653@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan>
	 <Pine.LNX.4.64.0706031146470.29896@twin.jikos.cz>
	 <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan>
	 <Pine.LNX.4.64.0706031300240.29896@twin.jikos.cz>
	 <Pine.LNX.4.64.0706030716070.3574@p34.internal.lan>
	 <Pine.LNX.4.64.0706031321450.29896@twin.jikos.cz>
	 <Pine.LNX.4.64.0706030749580.3653@p34.internal.lan>
X-Google-Sender-Auth: 61c046412080e48d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> On Sun, 3 Jun 2007, Jiri Kosina wrote:
>
> > On Sun, 3 Jun 2007, Justin Piszcz wrote:
> >
> >>> Thanks. Does by any chance reverting the commit
> >>> 9f8b17e643fe6aa505629658445849397bda4e4f improve the situation?
> >> I have not played around with git/etc enough to back it out, if you have a
> >> patch that applies on top of 2.6.22-rc3 that backs it out I can give it a try.
> >
> > Please try this
>
> [[ .. snip .. ]]
>
> The patch was successful and now my USB device is working again!

Please set:
  CONFIG_USB_DEVICE_CLASS=y
there should be no patch needed. The option already defaults to yes in
the latest kernel.

Thanks,
Kay
