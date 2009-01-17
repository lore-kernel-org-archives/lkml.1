Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZAQDA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZAQDA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 22:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZAQDAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 22:00:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58733 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZAQDAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 22:00:47 -0500
Date: Fri, 16 Jan 2009 22:00:46 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Eric Paris <eparis@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: WARNING: at kernel/trace/ftrace.c:434 ftrace_bug+0xdb/0x2b1()
 in 2.6.29-rc1-next-20090116
In-Reply-To: <alpine.DEB.1.10.0901162138410.9232@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901162200220.9232@gandalf.stny.rr.com>
References: <1232144843.6614.14.camel@localhost.localdomain>  <alpine.DEB.1.10.0901161939320.9232@gandalf.stny.rr.com> <1232158716.6614.20.camel@localhost.localdomain> <alpine.DEB.1.10.0901162138410.9232@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Jan 2009, Steven Rostedt wrote:
> 
> 
> Now the question is, how did that get listed twice?
> 
> Could you do a:
> 
> $ objdump -Dr -j __mcount_loc drivers/acpi/thermal.o 
> 
> and perhaps we can find a duplicate there?
> 

Actually, if you can post that file, that might help too.

Thanks,

-- Steve

