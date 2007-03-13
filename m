Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbXCMPyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbXCMPyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXCMPyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:54:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:12815 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbXCMPyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:54:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bwHmHvR4rXhqjn7tH/XEu9dJ19qPZUE2i0mwvy9K3YjHROi1H1KMvPBevytxd0Mq9NaKWtROru5/mgkV9gFPi23tDMgB7I3llwhVU/77TnDGMdk3PpJgal0QamqOxCIIunOQPJajGpXNXCxHb+IJgxWttnsI10cmOk9KWTApyvE=
Message-ID: <75b66ecd0703130853p4c7d029en2405caee4447d29e@mail.gmail.com>
Date: Tue, 13 Mar 2007 11:53:56 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Ash Milsted" <thatistosayiseenem@gawab.com>
Subject: Re: [ck] RSDL v0.30 cpu scheduler for mainline kernels
Cc: "Con Kolivas" <kernel@kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "ck list" <ck@vds.kolivas.org>
In-Reply-To: <20070313153514.428dc3e1.thatistosayiseenem@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703121058.11966.kernel@kolivas.org>
	 <20070313153514.428dc3e1.thatistosayiseenem@gawab.com>
X-Google-Sender-Auth: d93693f95c91cf73
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Ash Milsted <thatistosayiseenem@gawab.com> wrote:
> Desktop use whilst talking on Wengophone (run at nice -5): Under RSDL
> some GUI use e.g. opening a new folder in nautilus causes pops (buffer
> underruns) which do not occur with mainline. I suppose the changes in
> RSDL might require a lower nice value for equivalent performance, but
> (as a user) I am limited to -5.
>
> Low-latency audio with JACK and Ardour2: Rock-solid performance with
> either scheduler.. realtime works nicely.

Sounds like Wengophone is broken.  It should be using RT threads for
time critical work, as JACK and Ardour2 are doing.

No scheduler can help if the apps are not correctly written...

Lee
