Return-Path: <linux-kernel-owner+w=401wt.eu-S1750990AbXA3Ttd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990AbXA3Ttd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXA3Ttd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:49:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:38392 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXA3Ttc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:49:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G2HTW/n/s9IdcDW5Ag6EfwoUPYK+OSap8tACx/p3dDVdjj0nJ7nQOzNvBDHxQb9PmNa6jYfDAMjRpCuJZI2DHrD2bYW3+g2Kxt7mOle6LfIM3B0PpJsijfJ/ToEAu1qS8f85FR5KI8eg2GxrsQLU3zSm4xy2kh6lkGMvfxuwXkA=
Message-ID: <21d7e9970701301149r788c4053s2cea2c539e53bb99@mail.gmail.com>
Date: Wed, 31 Jan 2007 06:49:31 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: "Paul Collins" <paul@briny.ondioline.org>
Subject: Re: gpu sharing layer for kernel
Cc: airlied@linux.ie, benh@kernel.crashing.org, linux-kernel@vger.kernel.org
In-Reply-To: <87k5zbsfnu.fsf@briny.internal.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1169637623985-git-send-email-airlied@linux.ie>
	 <87k5zbsfnu.fsf@briny.internal.ondioline.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> airlied@linux.ie writes:
>
> > This patch series contains the gpu sharing layer for kernel that
> > I've mentioned before. It should apply against Linus's git tree.
>
> I gave the patches a go on my PowerBook.  I had to make a few changes
> to get it to compile.  Works fine so far: I switched between VTs and X
> with an accelerated GLX client active a few times, no problems.
>
> When I did a sleep/resume cycle it wedged on resume, but I expect this
> is due to my hacking up radeonfb_early_resume(), as seen in the last
> hunk below, which was just aimed at just getting it to compile.
>

Hi Paul,

I suspected some problem on PPC alright as I didn't have a radeon
based one to test on, I'll incorporate your changes and I'll fix the
suspend/resume to work properly :-)

Dave.
