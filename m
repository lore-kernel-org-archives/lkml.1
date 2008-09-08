Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYIHU5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYIHU5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYIHU5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:57:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39544 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYIHU5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:57:35 -0400
Date: Mon, 8 Sep 2008 13:57:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: alejandro.riveira@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Various OOps with 2.6.27-rc5
Message-Id: <20080908135736.5d0c3ef8.randy.dunlap@oracle.com>
In-Reply-To: <1220906182.15312.1.camel@Varda>
References: <1220815296.11776.4.camel@Varda>
	<20080908124641.9ec6887a.randy.dunlap@oracle.com>
	<1220906182.15312.1.camel@Varda>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2008 22:36:22 +0200 Alejandro Riveira Fernández wrote:

> El lun, 08-09-2008 a las 12:46 -0700, Randy Dunlap escribió:
> 
> [ ... ]
> > > The dmesg including oopses
> > 
> > Actually they are INFO: messages with getnstimeofday() being stuck,
> > similar to a few other reports on lkml.
> 
>  So is it useful to report them or i just do:
>  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>  And forget about it ??

I'm not sure.  I haven't followed the other problem reports very
closely.  AFAIK, it represents a real bug, but if your system is
running OK, you could just ignore it...


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
