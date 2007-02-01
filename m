Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXBARWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXBARWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbXBARWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:22:07 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:32633 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbXBARWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:22:06 -0500
Subject: Re: crash on CONFIG_CFAG12864B=y in 2.6.20-rc3-mm1
From: Daniel Walker <dwalker@mvista.com>
To: Miguel Ojeda <maxextreme@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <653402b90702010913g3d91b190ud4faa2bcce3251b@mail.gmail.com>
References: <1168188931.26086.255.camel@imap.mvista.com>
	 <653402b90702010549v17e72765uc718c1ae79419003@mail.gmail.com>
	 <653402b90702010716i7c0ddf71xe6fa7866323f52f4@mail.gmail.com>
	 <1170342991.9781.189.camel@imap.mvista.com>
	 <653402b90702010913g3d91b190ud4faa2bcce3251b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 09:20:33 -0800
Message-Id: <1170350433.9781.200.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 18:13 +0100, Miguel Ojeda wrote:

> >
> >
> 
> Well, I use the word "module" for both cases: When I modprobe
> cfag12864b, if ks0108 fails, it doesn't get linked. So I thought the
> same happen for built-in drivers (in other words, I didn't think
> cfag12864b would be linked if ks0108 failed).
> 
> So I'm waiting until someone tell me what is the right way to avoid
> drivers like cfag12864b been inited if their dependencies failed.
> 
> Anyway, thanks for discovering the bug (I wouldn't have discovered it
> as my motherboard has parallel port ;).

I have a parallel port, but I don't have the cfag12864b or ks0108 .. I
think the simplest way to fix it would be to add a flag to ks0108 that
signals successful initialization , then force cfag12864b to check for
that ..

I found this by booting a make allyesconfig kernel ..

Daniel

