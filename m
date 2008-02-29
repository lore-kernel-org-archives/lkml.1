Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbYB2L3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbYB2L3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYB2L3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:29:08 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756762AbYB2L3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:29:07 -0500
Date: Fri, 29 Feb 2008 03:29:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Olsa <olsajiri@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] soft lockup detected with ipcs
Message-Id: <20080229032902.a1a235df.akpm@linux-foundation.org>
In-Reply-To: <47C7E607.6090308@gmail.com>
References: <47C7E280.4010805@gmail.com>
	<20080229025707.971ce0bd.akpm@linux-foundation.org>
	<47C7E607.6090308@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 12:01:27 +0100 Jiri Olsa <olsajiri@gmail.com> wrote:

> Andrew Morton wrote:
> > On Fri, 29 Feb 2008 11:46:24 +0100 Jiri Olsa <olsajiri@gmail.com> wrote:
> > 
> >> when I run 'ipcs' my system freeze up immediatelly.
> >> I was able to get kernel BUG message once, I think it is not
> >> printed out all the time it freeze.
> >>
> >> I tried on 2.6.24, 2.6.20 and 2.6.18.
> >> I attached screenshot from 2.6.18 freeze and config.
> > 
> > how weird.  Lots of people are surely running ipcs and not seeing this.
> > 
> > Can you suggest what's different about your setup?
>
> no idea :) I noticed like 2 weeks ago... I probably changed some config,
> but I dont remember what it was, I'll try to figure out.
> 
> Anyway I can reproduce this immediatelly, so I can run any diag you'd need to see.
> 

(reversed top-posting - please don't do that ;))

Strange.  I guess as a first step it would be good if you can get a full
backtrace - can you set up netconsole
(Documentation/networking/netconsole.txt) and grab that?

We have your config.  Can you tell us how you're triggering it?  Does a
particular workload have to be run, or is it triggerable straight after
bootup?

Thanks.
