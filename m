Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbXCMAJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbXCMAJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 20:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXCMAJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 20:09:34 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:38433 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbXCMAJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 20:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nIO7itYg2RZdUiBjYydZidFuoFe8/1CfOS+kSeen9Jxewd00yELwQ2yU4HbZIJZ23sHAsS4Kw4ZQBrQG3voBQB4XpkCcVdK8jcsL7erUKgzaxWGDDKEAUWK/2ZczZ5EFies16bTEe91Zie6YcotV7rz5iKMvQniDvtXZtdkSfA0=
Message-ID: <7d01f9f00703121709p66381704ic2dc10e90fdbf3d6@mail.gmail.com>
Date: Tue, 13 Mar 2007 01:09:33 +0100
From: "Thibaut VARENE" <T-Bone@parisc-linux.org>
To: "michael chang" <thenewme91@gmail.com>
Subject: Re: [ck] Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Cc: "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <b14e81f00703121438q6cdaffd0vdb08e0386961f057@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703111457.17624.kernel@kolivas.org>
	 <200703130549.47058.kernel@kolivas.org>
	 <1173730314.6431.30.camel@Homer.simpson.net>
	 <200703130738.19034.kernel@kolivas.org>
	 <b14e81f00703121438q6cdaffd0vdb08e0386961f057@mail.gmail.com>
X-Google-Sender-Auth: 3af48500bcb0a678
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, michael chang <thenewme91@gmail.com> wrote:

> Considering the concepts put out by projects such as BOINC and
> SETI@Home, I wouldn't be thoroughly surprised by this ideology,
> although I do question the particular way this test case is being run.

If Con actually implements SCHED_IDLEPRIO in RSDL, life is good even
in that case.

> This seems to me like he's saying that there has to be a mechanism
> (outside of nice) that can be used to treat processes that "I" want to
> be interactive all special-like. It feels like something that would
> have been said in the design of what the scheduler was in -ck and is
> currently in vanilla.

Exactly. Driving us again toward the fact that different workloads
might benefit from different schedulers (eg: RSDL is cool for server
loads, previous staircase did an excellent job on desktop, etc) and
thus that having a choice of schedulers might be something that would
satisfy (some) people...

> To me, that fundamentally clashes with the design behind RSDL. That
> said, I could be wrong -- Con appears to have something that could be
> very promising up his sleeve that could come out sooner or later. Once
> he's written it, of course. In any case, RSDL seems very promising,
> for the most part.

It certainly is. "Negative" feedback can be a good thing too, as it
helps improving it anyway. It's nonetheless true that it's practically
impossible to satisfy 100% of use case with a single design, so
choices will have to be made.

HTH

T-Bone

-- 
Thibaut VARENE
http://www.parisc-linux.org/~varenet/
