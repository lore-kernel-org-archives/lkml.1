Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYDMH7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYDMH7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbYDMH7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:59:24 -0400
Received: from rv-out-0708.google.com ([209.85.198.244]:27964 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755096AbYDMH7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RU2/kQ4YYFGTntJxNB5RM/Zfe11lCVHcvpC04e3mBXNU/7thbNkt75OqjQxXwlCmkWfk6BYyijDxvjtWuuOylPm8sXA2trI+8AUnB6U4B/rTWHgtu6Gz0Zi7y1SJmjTBG3g4KQDeYzOwQN5D3O0alTAteuQoTuaeWuWtTjNoQ4E=
Message-ID: <86802c440804130059u52a61a82t39a6b1f788e78102@mail.gmail.com>
Date: Sun, 13 Apr 2008 00:59:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86 git tree broken (bisected)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <20080413075144.GI20332@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102159.14563.rjw@sisk.pl> <20080410203800.GA14560@elte.hu>
	 <200804110028.22290.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl>
	 <86802c440804111326t4c3ff4b6od33a128560b58aec@mail.gmail.com>
	 <20080413075144.GI20332@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 12:51 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > >  and X starts again.  Also, suspend to RAM works from under X.
>  >
>  > please keep the three patches and applied the two attached debug
>  > patches.
>  >
>  > i wonder if there is some io allocation overlapping with your system.
>
>  hm, would be nice to have these two debugging patches upstream. Perhaps
>  the printouts should be dependent on some boot parameter?

I am using them to print out the io/mmio allocation (from BIOS) before
kernel modifying them.

YH
