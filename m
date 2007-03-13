Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXCMUC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXCMUC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933085AbXCMUC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:02:27 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:51805 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbXCMUCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kFnGjLL8NhYJfDD2xyrFgpc77br5l+3ihmRdqWjr98dez+3ts8OTIlB5d0rDFxGnHYj1YfyYCWW/TANXZ/9gnsE0PX7cA3YiBn177rYYp+xJffx/71mmpDDmigwHx3PdQfhEa7McO4bji8jIJPG/R+OjkMAWQsB0HddWcMWB9fc=
Message-ID: <75b66ecd0703131302j32d58e7do5b0811e13c170c17@mail.gmail.com>
Date: Tue, 13 Mar 2007 16:02:23 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: [ck] RSDL v0.30 cpu scheduler for mainline kernels
Cc: "Ash Milsted" <thatistosayiseenem@gawab.com>,
       "Con Kolivas" <kernel@kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "ck list" <ck@vds.kolivas.org>
In-Reply-To: <45F6E34E.9020308@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703121058.11966.kernel@kolivas.org>
	 <20070313153514.428dc3e1.thatistosayiseenem@gawab.com>
	 <75b66ecd0703130853p4c7d029en2405caee4447d29e@mail.gmail.com>
	 <45F6E34E.9020308@nortel.com>
X-Google-Sender-Auth: acac65aaa6cba2a2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Chris Friesen <cfriesen@nortel.com> wrote:
> Lee Revell wrote:
>
> > Sounds like Wengophone is broken.  It should be using RT threads for
> > time critical work, as JACK and Ardour2 are doing.
>
> If the app has root privileges to set RT policy, then it could also set
> deeply negative nice values as well.
>
> Doesn't reallly help the regular user with no privileges.

Well this was supposed to be solved by RLIMIT_NICE and RLIMIT_RTPRIO
which went into mainline about a year ago but distros have been very
slow to pick up the new PAM, glibc and bash packages.  We don't have a
clear picture yet of what defaults the distros will ship.

Lee
