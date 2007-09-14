Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbXINQGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbXINQGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXINQG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:06:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbXINQG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:06:27 -0400
Message-ID: <46EAB179.4030805@zytor.com>
Date: Fri, 14 Sep 2007 09:06:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: EDD still failing on some systems with 2.6.23-rc6-git2
References: <46EAA9A1.1080100@redhat.com>
In-Reply-To: <46EAA9A1.1080100@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> I added debugging code to print a letter for each step in i386 setup,
> and it gets to 'J', then it hangs:
> 
>         /* Query EDD information */
> #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
>         putchar('J');
>         query_edd();
> #endif
> 
> Multiple reports of this happening on 2.6.23-rc6 can be found at
> the end of:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=251724
> https://bugzilla.redhat.com/show_bug.cgi?id=239585

I just attached a test patch to the bug report shown above.  If someone
with access to the relevant hardware could test out the patch, I would
greatly appreciate it.

	-hpa
