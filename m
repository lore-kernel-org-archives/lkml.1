Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbXLHGxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbXLHGxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 01:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbXLHGxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 01:53:40 -0500
Received: from hs-out-0708.google.com ([64.233.178.248]:28084 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159AbXLHGxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 01:53:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kKBp6JvPO6Hd7vu88WTDNwjbw0WblV9lnlj3wMRL7U36OFt6jVT6O4UWtuTN2rmfprhZ7pISV3L1svfLAOMl+rbpLEwkFA/LgzFVkSUlA2OMj0NDL6x1K9/V47wGGmQayVuSLwzaP48VjH/XlMfoTBpl8HREccEfrDGwrOHmCCs=
Message-ID: <b637ec0b0712072253k7f7410b6iaebf5b7b64ae4509@mail.gmail.com>
Date: Sat, 8 Dec 2007 07:53:38 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200712080340.49546.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712080340.49546.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Dec 8, 2007 3:40 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message contains a list of some regressions from 2.6.23 which have been
> reported since 2.6.24-rc1 was released and for which there are no fixes in the
> mainline that I know of. If any of them have been fixed already, please let me
> know.
>
> If you know of any other unresolved regressions from 2.6.23, please let me know
> either and I'll add them to the list.

<snip>

> Subject         : Battery shows up twice in kpowersave
> Submitter       : Rolf Eike Beer <eike-kernel@sf-tec.de>
> References      : http://bugzilla.kernel.org/show_bug.cgi?id=9494
> Handled-By      : Alexey Starikovskiy <astarikovskiy@suse.de>
> Patch           :
>

I don't think that this is a regression: I reported on RedHat bugzilla
when I switched from F7 to F8 and I was using 2.6.23.8 at that time.
It looks to me an HAL regression, but of course I may be wrong :-) as
the reported bisected to a bad commit.

https://bugzilla.redhat.com/show_bug.cgi?id=373041

By the way, I now switched to Fedrora Rawhide with a 2.6.24-rc4-git5
custom kernel and Gnome desktop and the problem is still present, even
with gnome-power-manager.

Hope this helps.
Regards,
Fabio
