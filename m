Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbXIYQsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbXIYQsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXIYQss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:48:48 -0400
Received: from gw.goop.org ([64.81.55.164]:42499 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbXIYQsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:48:47 -0400
Message-ID: <46F93BF0.20805@goop.org>
Date: Tue, 25 Sep 2007 09:48:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: osth@freesurf.ch
CC: linux-kernel@vger.kernel.org
Subject: Re: Xen kernel 2.6.23-rc7 bug at xen_mc_flush (arch/i386/xen/multicalls.c:68)
References: <46D217B100015CAD@mta-fs-be-05.sunrise.ch>
In-Reply-To: <46D217B100015CAD@mta-fs-be-05.sunrise.ch>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

osth@freesurf.ch wrote:
>> Hm, it just seems that its trying to unpin an mm on the error path of
>> execve, and so it hasn't been pinned.  The simplest way to reproduce is:
>>     
> ...
>   
>> Anyway, try this patch.
>>     
> Bug is solved by this patch. Thanks! - Maybe this patch can make it into
> 2.6.23 final?
>   

Yes, I'll send it out today.

    J
