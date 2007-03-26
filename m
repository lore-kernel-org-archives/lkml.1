Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbXCZTjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbXCZTjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbXCZTjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:39:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:34000 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbXCZTjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E82zW2yLzbDTiZx3aJnwJXqDvz4w+pw2S7SEwjvFZr6sfy8G0hRrbfdCdaKJT7tDJTJfBDQFKUXKIF9Nl5aOnxnRrJgBm7vmguTONm6g9RWkXo8OUrm5rbckDujBQE/WylKKZzuSokzDoMzHSQCHRV91KkrL56xk2gwdZuzpbRU=
Message-ID: <87d3b2040703261239m3e1dd5depd1884d80157f4a6a@mail.gmail.com>
Date: Mon, 26 Mar 2007 21:39:29 +0200
From: "Frederic Riss" <frederic.riss@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       "Tino Keitel" <tino.keitel@gmx.de>
In-Reply-To: <20070326190233.GE16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185022.GQ752@stusta.de>
	 <1174858456.5550.32.camel@funkylaptop>
	 <1174891519.5550.36.camel@funkylaptop>
	 <1174900493.4182.14.camel@chaos>
	 <1174935200.5550.43.camel@funkylaptop>
	 <20070326190233.GE16477@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/26, Adrian Bunk <bunk@stusta.de>:
> On Mon, Mar 26, 2007 at 08:53:20PM +0200, Frédéric Riss wrote:
>
> >... (In fact it hangs at the second suspend, but that's another ATA
> > problem that I think has already been reported).
>
> This sounds like the MSI problem.
>
> Do you have CONFIG_PCI_MSI enabled?
> If yes, does disabling it fix it?

Yes

> If yes, does CONFIG_PCI_MSI=y with the patch from [1] work?

Yes !

Just to be 100% clear, the hang I was seeing at the second suspend is this one:

Subject    : second suspend to disk in a row results in an oops  (libata?)
References : http://lkml.org/lkml/2007/3/17/43
Submitter  : Thomas Meyer <thomas@m3y3r.de>
Status     : unknown

I'm not sure it was associated with the MSI issue yet.

Thanks a lot,
Fred

> [1] http://lkml.org/lkml/2007/3/24/136
