Return-Path: <linux-kernel-owner+w=401wt.eu-S1750772AbXBKSlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750772AbXBKSlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbXBKSlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:41:47 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:22369 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXBKSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:41:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E3P0DE0I3ftJgL1gE2FsQfFyIAIAJCvtcWibIpZm/f+DlIpZWtVvK0u9WaCMnbsBf+V9bQUNqZnw6M9aq4pKg4oqy5ZT790SSJJyMjR0SKS/MB32PhXKsEegCUeWHW9pEGabx71I/6qYJO3kxtugmJ1T4QcAat2wPs/Yi2AKoFc=
Message-ID: <8d158e1f0702111041m24a631dawf415a26d327a4d37@mail.gmail.com>
Date: Sun, 11 Feb 2007 19:41:44 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: libsata doesn't like bus without master
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45CF619D.6000704@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.OcrmlkSFqen95BGHXWJdR6KGswQ@ifi.uio.no>
	 <fa.mIV6AQH7D5yiY39XNxbu0M2/1Kc@ifi.uio.no>
	 <fa.3Ti1gtH2JY4DWsqr3J1loC7lcc0@ifi.uio.no> <45CF619D.6000704@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Patrick Ale wrote:
> > On 2/11/07, Robert Hancock <hancockr@shaw.ca> wrote:
> >> Patrick Ale wrote:
> Then in that case you should set the remaining drive as master. That's
> just the way PATA is. A lot of BIOSes won't even detect a drive that's
> set as slave with no master present.

Yea, I guess you're right. For me it isnt a problem, This error
message will disappear for me anyway, since I am going to re-add the
drive now, like I said yesterday, I am re-adding stuff one by one, to
isolate problems.

I can just imagine that switching a jumper might not be as easy for
everybody, especialy when they bought special front-loading harddisk
bays for their disks and all, for the very reason of not having to
open the case.

> Yeah, that's a better point. It's not really complaining, but we could
> probably have a better way of suppressing that message. I think it's
> largely there so that we can debug issues with drives not being detected
> when they should.

It's not like it is causing any problems, nothing hangs or slows down
at boot time, its just something I came across when checking my dmesg
and wanted to inform the list so I could see if this was normal
behaviour or not :)


Patrick
