Return-Path: <linux-kernel-owner+w=401wt.eu-S1761373AbXEKHoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373AbXEKHoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbXEKHoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:44:37 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:58746 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755009AbXEKHog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:44:36 -0400
Date: Fri, 11 May 2007 09:44:29 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Matt Reimer" <mattjreimer@gmail.com>
Cc: "Pierre Ossman" <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
Message-ID: <20070511094429.6390e1a9@dhcp-252-105.norway.atmel.com>
In-Reply-To: <f383264b0705101051r4c8ebc73hc7f6119393fe46c9@mail.gmail.com>
References: <117879333788-git-send-email-hskinnemoen@atmel.com>
	<46430A49.9090803@drzeus.cx>
	<20070510143737.54969394@dhcp-252-105.norway.atmel.com>
	<46432212.9070008@drzeus.cx>
	<20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>
	<46434123.8040801@drzeus.cx>
	<20070510182749.219351cb@dhcp-252-105.norway.atmel.com>
	<f383264b0705101051r4c8ebc73hc7f6119393fe46c9@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 10:51:50 -0700
"Matt Reimer" <mattjreimer@gmail.com> wrote:

> On 5/10/07, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> > Btw, how can I wait for the scanning to complete from early userspace?
> 
> A workaround is to pass the kernel argument rootdelay=5 or something
> like that (the value specifies seconds).

Yeah, I know. It's just that this is still a workaround and I wanted to
fix the real issue. But if the real fix is "use initrd", I guess I'll
just have to look into that...

Haavard
