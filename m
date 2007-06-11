Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbXFKNry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbXFKNry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 09:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXFKNrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 09:47:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:45989 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbXFKNrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 09:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RN/QVVH+X4N8erjGdcHcyIRhNnU5MOEcAoBpxWn6XsB5YL+KDWhlbC1ScKRhLatTyV4tz4M/rtvwNRce302/kQflL9d28sGDoQfl/jdxS3RJpabqZwB6jc67oxb09TlRxHg9SSD+l6e6o24C0+VV7ts5dGwt1HPqtL+gaF5oZak=
Message-ID: <5bdc1c8b0706110647j30e95d3en3ca70470524fb8e2@mail.gmail.com>
Date: Mon, 11 Jun 2007 06:47:39 -0700
From: "Mark Knecht" <markknecht@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.21-rt9 - IRQ23 consuming a steady 2.7% of CPU
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Lee Revell" <rlrevell@gmail.com>
In-Reply-To: <20070611075722.GA9852@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5bdc1c8b0706100946k3acd6374uac8248e78f97433d@mail.gmail.com>
	 <20070610172452.GA7560@elte.hu>
	 <5bdc1c8b0706101038q2f0e3418t1a595e749b5bfe71@mail.gmail.com>
	 <20070610180745.GA14912@elte.hu>
	 <5bdc1c8b0706101344o78d202dcx5cfdaea0fd73ddf7@mail.gmail.com>
	 <20070611075722.GA9852@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Mark Knecht <markknecht@gmail.com> wrote:
>
> > Hi Ingo,
> >   Yep, that solved it on my machine. I did have to patch using 'patch
> > -p1 -R' I think that's because the paths in your patch file are maybe
> > based on your work setup? I don't know. I'm amazed most of the time
> > that I can even do this stuff but with your help it seems to work out.
> > Thanks.
> >
> >   Anyway, top no longer reports the 2.7% CPU usage from IRQ23. I do
> > see a little bit of CPU consumption from X and firefox but that seems
> > pretty reasonable.
>
> ok, thanks - i took that change out from -rt.
>
>         Ingo
>
Thanks Ingo. Have a great week.

- Mark
