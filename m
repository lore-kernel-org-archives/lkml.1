Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbXLOAAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbXLOAAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 19:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXLOAAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:00:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:37862 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbXLOAAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:00:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a7sFmH/wGhwOMl2DLRpn7vDFboUK7YSVvjRNl0KQ+oyzdHI8iMHBMyv6F/q06qnc9LyeE9DeVcC0QjiAAuUQDl4xzYLF2IIOny+ppoQU6pA/riag0th+Fi/8LpkcZhYgWc7NfVhySMxcTptyOKI4oYuWxHk8Kg2QyN0T0XlTrKw=
Message-ID: <9a8cbed90712141600l1a867da0uc7027e502575a7a6@mail.gmail.com>
Date: Fri, 14 Dec 2007 19:00:40 -0500
From: "Arun Thomas" <arun.thomas@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jiri Slaby" <jirislaby@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4762D322.2060101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>
	 <20071214015315.09829a99.akpm@linux-foundation.org>
	 <9a8cbed90712140201r6cb287d9w99cc1210c68e8e60@mail.gmail.com>
	 <4762586F.8090603@gmail.com>
	 <alpine.LFD.0.99999.0712141140310.10584@localhost.localdomain>
	 <4762D322.2060101@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 2:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Thomas Gleixner wrote:
> >
> > The problem is caused by an SMI during the calibration routine. We
> > really need to come up with a solid solution which does not rely on
> > the periodic timer coming in, when there is something else (HPET,
> > pm_timer) available.
>
> How long is the SMI?

Is there some instrumentation code somewhere which would allow me to
determine this? If not, can you give me some hints on where to add the
instrumentation code?

Thanks,
Arun
