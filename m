Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbYDCCJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbYDCCJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbYDCCJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:09:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:38924 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112AbYDCCJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BugIGRxh6R79ZAe7c45QPwAPRMcUBmKj73Y0ew5tDcpr2TP/OWZ2gikP1vkAMiiUNbkzpGTX0sMqJqMcXFtmgVBKuxtWJsSRcNtDKMQHdNsbvZYZAPBUI7K6BRL499VtI5bxhKibxjLkNOJiti9V/7lbBgArLWw+ojA5S58cCns=
Message-ID: <72dbd3150804021909ie877298hd1cbebd3a0e00fd9@mail.gmail.com>
Date: Wed, 2 Apr 2008 19:09:18 -0700
From: "David Rees" <drees76@gmail.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: linux-2.6.25-rc8, an oddity
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200804022027.11942.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804022027.11942.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 5:27 PM, Gene Heskett <gene.heskett@gmail.com> wrote:
> This will be the third time I've sent this message in about 10 hours, with it
>  never making it to the list, but I've picked up around 400 messages since
>  because I am subscribed.  Please check as to why I cannot post?

Your post made it to the list all three times (or at least, I received
it, and I suspect just about all the other LKML readers have, too if
they haven't blacklisted you now for spamming the list).

>  1. I note when I logged in (always to runlevel 3, no x at that point) that it
>  gave me tty1, instead of the usual tty0.
>
>  Is there a reason why the non-x login screen wasn't /dev/tty0?  It does
>  exist..

The normal first tty to use is tty1. At least all my Fedora/CentOS
systems start with tty1. Not a bug.

>  2. Also, if I exit x, expecting to see my original screen, its not there, no
>  drive at all to the monitor so it shuts down.  I think I can blindly startx
>  again, or type reboot, or give it the vulcan nerve pinch but I don't get
>  video back until the reboots post finds it.  This is regardless of the kernel
>  running apparently I've tried fedora's latest, 2.6.24.4, and now 2.6.25-rc8.

Sounds like an X driver bug, not a kernel bug to me. Check with the
xorg guys or with your Linux distro vendor.

-Dave
