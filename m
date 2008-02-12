Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbYBLHQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbYBLHQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbYBLHQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:16:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:51630 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbYBLHQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:16:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=raSgK2z5vvM75vRtcBtzu+rYR2ypzu2kJC57RawR5PE+5Qy30T9mE1mqqi5DEQx76mtunqimUUdIXW8w+Tee7a2UUqigUoOBWsiY0Ign6SNZRG2JFBgxmh0WLNscV24RLAN5VZdADNOMuYmSrUgMWElJpUJfh6tYO7B8584y6QE=
Message-ID: <877aabc40802112316t21d03114mc5b1f0411c019955@mail.gmail.com>
Date: Tue, 12 Feb 2008 12:46:03 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Sergey Vlasov" <vsu@altlinux.ru>
In-Reply-To: <Pine.LNX.4.64.0802101326270.7699@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080130011550.GA31853@elte.hu>
	 <f77718aa0802090611n240bfa5avbbe2abeb53607f48@mail.gmail.com>
	 <Pine.LNX.4.64.0802101326270.7699@twin.jikos.cz>
X-Google-Sender-Auth: 69826b497170aa61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 6:00 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 9 Feb 2008, Amit Shah wrote:
>
> > cc503c1b "x86: PIE executable randomization" doesn't boot on my Ubuntu
> > Feisty Fawn Intel Core2 system.
> > I get numerous segfaults before getting a (initramfs) busybox shell. A
> > similar bug was reported much earlier:
>
> [ please, when you experience a problem and are able to identify the
> commit that triggers it, don't forget to CC the author of the commit in
> question -- me, in this case ]
>
> As far as I remembers, Ubuntu uses klibc in initramfs, right?
>
> What version of klibc do you have? There was a bug in klibc that causes
> such behavior on PIE-randomization-enabled kernels, and has been fixed in
> klibc-1.45 by commit [1]. Please make sure you have updated klibc version
> that doesn't contain this bug.

Thanks Jiri.

>
> [1] http://git.kernel.org/?p=libs/klibc/klibc.git;a=commit;h=10df6dfb13ffefe716f12136bbc667f18ff64744
>
> --
> Jiri Kosina


-- 
Amit Shah
http://www.amitshah.net/
