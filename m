Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0BMHre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 02:47:34 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:43465 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0BMHrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 02:47:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NRJjlLYmmq3fQU/1G5EdpYzWUjUI+jlASFMpCuYnnEv5tTwo6gFNoaV4G6Ku23r/2W
         ZXJcKYhqBTAY0lsQPLDwYD4qnGRw9IGfhNW+iHLzJz8yagA2sb88eHG15P9DEzz06/u+
         3oYHGEE8XpIHL+dULEFHdzx1PySoO3CyxdlOc=
MIME-Version: 1.0
In-Reply-To: <4B75A5FE.8020408@zytor.com>
References: <4B744E13.8040004@kernel.org>
	 <20100212150137.648dca7c@hyperion.delvare>
	 <4B75A5FE.8020408@zytor.com>
Date: Fri, 12 Feb 2010 23:42:04 -0800
X-Google-Sender-Auth: fac94178c1290de9
Message-ID: <12c511ca1002122342x6a85459aic31f5c7e8f3786c1@mail.gmail.com>
Subject: Re: [kernel.org users] XZ Migration discussion
From: Tony Luck <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jean Delvare <khali@linux-fr.org>, "J.H." <warthog9@kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 11:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> It might open up the question if we shouldn't just do a Solaris and drop
> the leading 2 (so the next kernel would be 6.33) or call the kernel
> after that 3.0 instead of 2.6.34, and then 3.1 instead of 2.6.35.

This sounds like a good plan (and since we have so
far failed to come up with some new feature in Linux
that is so awesome that it warrants bumping the
version number to 3.0 ... we might as well manufacture
one, and "The HTML for the archive directory on
kernel.org has gotten too big" seems a pretty good
reason to me).

So the plan could be:
1) Declare 2.6.35 (or so) to be the last in the 2.6 series.
2) Define a better archive directory structure for the 3.x
releases (scripts will have to be changed anyway to
handle the 3.x change)
3) Keep all the .gz and .bz2 in the old 2.x hierarchy
4) Only have .xz in the new 3.x directories.

This should give time for people to update scripts
and for xz compression tools to become widely
available.

People on the bleeding edge versions are the most
likely ones to update their tools promptly. People
still using 2.x series kernels can keep using their
old tools forever.

-Tony
