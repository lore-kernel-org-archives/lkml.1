Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbXINUAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbXINUAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbXINUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:00:27 -0400
Received: from gw.goop.org ([64.81.55.164]:33466 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbXINUAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:00:25 -0400
Message-ID: <46EAE850.1000503@goop.org>
Date: Fri, 14 Sep 2007 13:00:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH] Add ELF note with Linux version
References: <20070904150018.GA4357@suse.de> <46DFD825.2020109@goop.org> <20070913144228.2efcd5d9.akpm@linux-foundation.org> <46E9B22B.1000002@goop.org> <20070914075234.GI30366@suse.de>
In-Reply-To: <20070914075234.GI30366@suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> [2007-09-13 23:56]:
>   
>>> I'd like to know a little bit more about why this is needed, how it will be
>>> used, etc.  And given that this feature is intended to improve life for
>>> distributors, it would be nice to get some feedback from the appropriate
>>> persons.
>>>       
>> Hm, yes.  ELF notes don't appear in the bzImage, since it isn't an ELF
>> file, so perhaps this doesn't satisfy the requirement.  It would help to
>> have more detail.
>>     
>
> the bzImage already contains the version (and much more, e.g. if the
> kernel is relocatable, the command line length it accepts). See
> Documentation/i386/boot.txt.
>   

Yes, I'm familiar with that.  I'm wondering what end result you're
trying to achieve though.  What's the specific problem?

    J
