Return-Path: <linux-kernel-owner+w=401wt.eu-S1765260AbXJSQ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765260AbXJSQ7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 12:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbXJSQ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 12:59:07 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:41128 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbXJSQ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 12:59:06 -0400
Message-ID: <4718E24F.3060805@nortel.com>
Date: Fri, 19 Oct 2007 10:58:55 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Samuel Tardieu <sam@rfc1149.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: OOM notifications
References: <20071018202504.GA2854@dmt> <4717C43D.6030204@keyaccess.nl> <20071018165238.0537eaa6@bree.surriel.com> <4717CAEC.50203@keyaccess.nl> <20071018171857.409255de@bree.surriel.com> <4717D7B6.40102@keyaccess.nl> <4717D9BF.4010508@redhat.com> <20071019101743.GA24354@elf.ucw.cz> <87lk9zgmkx.fsf@willow.rfc1149.net>
In-Reply-To: <87lk9zgmkx.fsf@willow.rfc1149.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2007 16:58:59.0552 (UTC) FILETIME=[57E88600:01C81271]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Tardieu wrote:
>>>>>>"Pavel" == Pavel Machek <pavel@ucw.cz> writes:

> Pavel> That works okay on a PC, but try cellphone one day.
> 
> Pavel> You want management app to close the least used
> Pavel> application. You do not want _kernel_ to select "who to send
> Pavel> SIGTERM to".
> 
> That's why I would prefer that *all* processes receive the
> SIGDANGER/whatever (and of course ignore it by default). Only the
> management app would handle it in the case you describe and would
> select one or more applications to unload to free some memory.

It's still helpful to have two stages...one that all apps can listen to 
(and try to reduce their footprint if possible), and a second one that 
only the manager would handle (and would kill some suitable target). 
Finally, if all that fails then the kernel starts whacking things.

Chris
