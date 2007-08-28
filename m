Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbXH1OVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbXH1OVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXH1OVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:21:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:9892 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbXH1OVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cco1POUeCODIZuoC+OstK7DrGxHelxG2NuAnUg3beOePu6mp+2/9YJRzaqtsToumzHJz4DG2fb3NeWbH6M+uJZFWVKYVN4HmTgu7oCuv+7ZoSvSs5OIg/Zw7oC03nNqH/SIpdMI9KPG+/86DIg/zmZXQ2piUzht+VdZUCgKtdSg=
Message-ID: <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
Date: Tue, 28 Aug 2007 22:21:34 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Cc: rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070827213248.GF3398@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070827104350.GA2073@elf.ucw.cz>
	 <20070827105801.GA4053@elf.ucw.cz>
	 <b6a2187b0708270736q5cfc180fp3c223a57ea6904f9@mail.gmail.com>
	 <20070827213248.GF3398@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Pavel Machek <pavel@ucw.cz> wrote:

> Can you try 20-or-so tests? Mine hangs randomly, so it survived 4 or
> so cycles at one point.

Mine still survives with this ... with sleep 1 ...

# for((i=0; i<100; i++)); do echo $i; echo $((i % 2))
>/sys/devices/system/cpu/cpu1/online; sleep 1; done

and this as well ... without sleep ...

# for((i=0; i<100; i++)); do echo $i; echo $((i % 2))
>/sys/devices/system/cpu/cpu1/online; done

I'm on reiserfs. gcc 3.4.5. Config sent to you seperately so as not to
cloud lkml. If anyone wants the config, please let me know. Is mime
"attachment" acceptable now on lkml?

Thanks,
Jeff.
