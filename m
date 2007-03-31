Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXCaGol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXCaGol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 02:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933586AbXCaGol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 02:44:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:25945 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbXCaGok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 02:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AAsGrQhA2pKtoYt6hSi4rj557pfcoL5Wu9OZyopkweNXn2W0IBXE6o9gz1JGjW5ZrgDfOV4wPRlSNL4gajpwnjRXbDy/5h0yvwZprxc2lYR36K85bHTCaHcZc9hPbZ10PWnJjT+lx8lPbnGlhkAiXqJB6JSFutIDN0kdsKcZOGk=
Subject: Re: [4/4] 2.6.21-rc5: known regressions (v2)
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tino Keitel <tino.keitel@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       pavel@suse.cz, linux-pm@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070330214956.GQ14134@stusta.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	 <20070330214956.GQ14134@stusta.de>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 31 Mar 2007 08:44:39 +0200
Message-Id: <1175323479.5550.70.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 30 mars 2007 à 23:49 +0200, Adrian Bunk a écrit :
> Subject    : MacMini doesn't come out of suspend to ram  (i386 clockevents)
>              (CONFIG_HPET_TIMER)
> References : http://lkml.org/lkml/2007/3/21/374
> Submitter  : Frédéric Riss <frederic.riss@gmail.com>
>              Tino Keitel <tino.keitel@gmx.de>
> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
>              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> Status     : unknown

This one has been fixed by 399afa4fc9238fbae42116cf25a54671c0e8f56e.
Suspend to ram now works with HPET enabled (and regardless of the NO_HZ
setting).

Thanks!

Fred.

