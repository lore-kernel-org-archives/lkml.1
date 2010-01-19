Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369Ab0ASTmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0ASTmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261Ab0ASTmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:42:22 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:58159 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab0ASTmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:42:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dvyxH98SEoRbKMGjzoeNw3BGzPjrHSq1hajGGhvcYU9lMNlxoKni0JT2Hkp870KrmC
         JlJM2Am/V5BZVUTOJp6vi0GPF5FEM4oSTqK4h4Sj8WedOhlTJi/HsmweilVVW1aHNofI
         MU2UrpssAnotwyDMTouLG0ypl1hj9R0bc5Bh8=
MIME-Version: 1.0
In-Reply-To: <20100119192626.GA31490@kroah.com>
References: <3194316b1001191119h6c15dd2bvbf32bf93a2d1730e@mail.gmail.com> 
	<20100119192626.GA31490@kroah.com>
From: David Holm <dholmster@gmail.com>
Date: Tue, 19 Jan 2010 20:41:59 +0100
Message-ID: <3194316b1001191141g60866961k1456ec861734eca1@mail.gmail.com>
Subject: Re: [PATCH] Backport of Sierra Wireless USB serial driver from 2.6 to 
	kernel 2.4.37
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux@sierrawireless.com, klloyd@sierrawireless.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 8:26 PM, Greg KH <greg@kroah.com> wrote:
[snip]

> Minor complaint, your email client wrapped the patch, so it would have
> to be edited by hand in order to apply it.

I made it available on my webserver, if nothing else for posterity.
http://www.dholm.com/files/sierra-2.4_1.7.16-1.patch

> Main question though is, why did you do this?  Is there some reason you
> are stuck with such an old, and unsupported kernel version that you
> required this driver?  What is keeping you from moving to a 2.6 kernel
> on this hardware platform, and can we help you out with that in any way?

The platform we are working on is no longer supported by the vendor
(which I would prefer not to name) and they only supplied GCC 2.95.3
(with a coupld of ARM-specific patches) and a choice between Linux
2.4.22 or 2.4.26. On a couple of occasions I made some half-assed
attempts at upgrading GCC to 3.x and 4.x using vanilla releases but I
could never get them to produce stable binaries.

If I had more time I would do the work but since I'm the only one who
knows the low level stuff like the back of my hand I rarely have any
time to spare on such a project. As it stands we are getting by on the
toolchain we have and there have only been a few roadblocks along the
way which have since been removed.

> Otherwise, looks fine at first glance, but I don't know what to do with
> the patch as no one is doing 2.4 work upstream anymore except for
> security and other minor bugfixes.

I was afraid of that but posted it anyway hoping someone forced to
work in a similar environment as us to find it useful.

Thanks for getting back to me so fast. Hopefully I will be able to
work on never kernels in the not so distant future and come up with
more interesting patches. :)

Sincerely,
David
