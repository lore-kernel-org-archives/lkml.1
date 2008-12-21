Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYLUPRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYLUPRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbYLUPRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:17:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:9223 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYLUPRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:17:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EBhAiqcKiN9eqbLEThihQBsNTn1S/TsFrUb/jWufkTH55+dN5ynbUQxbS3a25WgVfy
         vmugHRDFySHU72UiA5m/ZY6WW9hNKH+vcU6iLELIDDVZqdHPeGY4rOYiEW8cYs8Lgez9
         zQOoytjjBqNjnp1k2TcdcHufiQbIveHlaELZQ=
Message-ID: <f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com>
Date: Sun, 21 Dec 2008 10:17:39 -0500
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Anssi Hannula" <anssi.hannula@gmail.com>
Subject: Re: 2.6.28-rc9: USB Mouse unhappy
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <494E20F7.7050106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>
	 <20081220221253.e09b1b1f.akpm@linux-foundation.org>
	 <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com>
	 <494E20F7.7050106@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 5:56 AM, Anssi Hannula <anssi.hannula@gmail.com> wrote:
>
> This sounds to me like 'usbmouse' gets used instead of 'usbhid' on
> 2.6.28-rc9. Many users have reported only vertical movement with
> 'usbmouse'. Better check the kernel configuration, if you had usbmouse
> disabled in 2.6.27, then disable it with 2.6.28-rc9 as well.

Sure enough - rmmod usbhid; modprobe usbmouse reproduces the exact
same problem on a working kernel.

But the thing is I use the same base configuration across all kernels
I build (sans of course the newly added config options) - so something
changed somewhere and now usbmouse gets used instead of usbhid.

What's the deal with usbmouse though - is it supposed to be working or
is it considered lost cause in favor of usbhid? May be if people don't
need to use it and it is not actively looked into, we can
disable/remove it?

Thanks

Parag
