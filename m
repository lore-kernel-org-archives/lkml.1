Return-Path: <linux-kernel-owner+w=401wt.eu-S1031208AbXEAMv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031208AbXEAMv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031209AbXEAMv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:51:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:17588 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031208AbXEAMv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kpW+uSeiYtQ7W8DB/qB7uTq7ypivaOl/Np1Qo+jYO1fSyWYWaYWBua3LzXPaKLLGOTGk/hAhwr7g43EfqmUGwdG7b2r91vU449zQlU8sBP/ybW5xr15ZoeF0oQ/phdFwLP5SOm7b/OPKUjFXgQZ57lFCGp5zHxZRQ0DlK8zmeQE=
Message-ID: <b6a2187b0705010551h38c1e97av9ddcc096862808d3@mail.gmail.com>
Date: Tue, 1 May 2007 20:51:55 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: VMware, x86_64 and 2.6.21.
Cc: nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705011309050.18504@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177998147.8981.16.camel@nigel.suspend2.net>
	 <b6a2187b0704302313p4cb7924bj506d68a1c1b6fb41@mail.gmail.com>
	 <Pine.LNX.4.61.0705011309050.18504@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> On May 1 2007 14:13, Jeff Chua wrote:
> > On 5/1/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> >> Hi.
> >>
> >> Does anyone have VMware working on x86_64 with 2.6.21? It's working fine
> >> for me with 2.6.20, but freezes the whole computer with 2.6.21. Before I
> >
> >
> > I'm on i386 and noticed it makes the "guest" very unresponsive.
> >
> > Uncheck "disable write-caching" solves the problem.
>
> Why do you even have "disable wc" turned _on_? (Yes, it's a VMware 5 bug where
> it gets randomly set upon machine creation, VM WS 6 has it fixed.)

I thought so too, never knew it was defaulted on, until I poked around
and realized that it was the culprit.

I'll wait for the stable WS6 to be released. Right now, WS5 is good
enough for me.

Thanks,
Jeff.
