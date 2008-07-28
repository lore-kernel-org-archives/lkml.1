Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYG1Tup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYG1Tup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYG1Tuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:50:37 -0400
Received: from gw.goop.org ([64.81.55.164]:56513 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbYG1Tug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:50:36 -0400
Message-ID: <488E2309.8090402@goop.org>
Date: Mon, 28 Jul 2008 12:50:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH] xen: xen: compile irq functions without -pg for ftrace
References: <488E15C5.3070902@goop.org> <20080728193235.GB11431@uranus.ravnborg.org>
In-Reply-To: <20080728193235.GB11431@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Jul 28, 2008 at 11:53:57AM -0700, Jeremy Fitzhardinge wrote:
>   
>> For some reason I managed to miss a bunch of irq-related functions
>> which also need to be compiled without -pg when using ftrace.  This
>> patch moves them into their own file, and starts a cleanup process
>> I've been meaning to do anyway.
>>
>> [ Sam, Ingo: I think the problem was that I enabled CONFIG_FTRACE
>>  but didn't do a clean build.  Shouldn't the build-system notice
>>  that the config changes the CFLAGS and rebuild everything?  That
>>  didn't seem to happen in this case. ]
>>     
>
> The build system usually does this.
> And I have no reports that this has regressed until now.
> What file?
> Can you tell me how to reproduce it?
>   

OK.  It was just a suspicion.  I'll try to confirm what's really going on.

    J
