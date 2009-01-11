Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZAKQ4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZAKQ4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZAKQ4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:56:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:55861 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZAKQ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:56:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j/xYYCpQMGA+JWXgGer/KXUviYpjSQqmxzprrxje4koPb0L51+KoEj1s2bwHdKHURP
         cbiatnvTejgip2ZIWMFXaBZ6cPQG9OI8NzWTsM+NHjzJD6jwOyJNyoFDVgeKsrIxyhpK
         foGPAydHmNl+Yjy1Pyn2vu8tVVLNiRU/FrF2c=
Message-ID: <b6a2187b0901110856j3f2ff6fepc19a816178e38a95@mail.gmail.com>
Date: Mon, 12 Jan 2009 00:56:29 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Cc: "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Daniel Drake" <dsd@gentoo.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Phil Dibowitz" <phil@ipom.com>
In-Reply-To: <20090111163904.GA21806@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com>
	 <20090111162949.GA15338@elte.hu>
	 <200901111736.24350.borntraeger@de.ibm.com>
	 <20090111163904.GA21806@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 12:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Christian Borntraeger <borntraeger@de.ibm.com> wrote
>> I guess Jeff, meant the other way around.
>> Since a0e280e0f33f6c859a235fb69a875ed8f3420388 is a fix for a known S2R
>> problem , the earlier patch (before) does of course not work.
> ah, okay.
> So i suspect that at every bisection point, this should be done:
>  git cherry-pick a0e280e0f33f6c859a235fb69a875ed8f3420388

I started with the latest git, and did this ...

git bisect start
git bisect bad
git bisect good a0e280e0f33f6c859a235fb69a875ed8f3420388

Everything in-between should have
a0e280e0f33f6c859a235fb69a875ed8f3420388 applied?

Jeff.
