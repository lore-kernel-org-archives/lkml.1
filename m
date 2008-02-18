Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbYBRJoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbYBRJoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYBRJns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:43:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:22627 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYBRJnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:43:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VEqXV8Ncq0NrFKhyHeuZCAFBzY7610hHb5eU+81bgww0IZJIQmU6x5N/QnIDtsSQ2anHP3QEXaaOLarp5f6S0kz1yafJ3KwiCYH/BsDOOTm5wfjPczwdsrgfgSki8OA4+zu6EXZLOY8vXU8gyBl8Dcv1Bd/FXFlD0pJxWD1Yudo=
Message-ID: <b6fcc0a0802180143u65120b97wa87d59eb17f37ed2@mail.gmail.com>
Date: Mon, 18 Feb 2008 12:43:44 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Tilman Schmidt" <tilman@imap.cc>
In-Reply-To: <47B9473D.20508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802172304.00322.rjw@sisk.pl> <47B9473D.20508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/08, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 02/17/2008 11:03 PM, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10021
> > Subject		: Linux 2.6.25-rc2 regression: LVM cannot find volume group
> > Submitter	: Tilman Schmidt <tilman@imap.cc>
> > Date		: 2008-02-16 20:14
> > References	: http://lkml.org/lkml/2008/2/16/208
> > Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
>
> NOTABUG, http://lkml.org/lkml/2008/2/17/386

Wow! Please delete CONFIG_SYSFS_DEPRECATED and make it always Y, then.

1. Box is running fine.
2. Kernel upgrade -- sysfs layout changes -- box breaks.
3. sysfs people tell everyone to upgrade userspace or turn on shiny new option
4. Some believe this, upgrades userspace. Option is not needed now,
BTW. It's turned off.
5. Several more kernel upgrades were fine.
6. 2.6.25-rc1 comes out and, who would have thought, requires to turn
on that damn
   option again or else box simply doesn't boot.

Why on earth do we have CONFIG_SYSFS_DEPRECATED at all if the only
sane choice for someone who tests new kernels is to always turn it on?
