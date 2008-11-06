Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYKFGDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYKFGDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYKFGDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:03:00 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:16366 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYKFGC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:02:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=tI5v/pXYzEjkkmxxeoeo0uO8DB13S4G4cZWB5cgQwLnRnPtjR2HKp4+R6esNjyI6As
         qF7RNS1tl0KXnItP02EyJ4TIio3CFYhg9AM90b+XUj70JX6U3B6bwhaCnzw6t2ZciAjO
         D+aAgI5xzLcUdqyRvk53uCGeo3QDubNCDn6pU=
Message-ID: <86802c440811052202of38d85l3801445d6db59ee5@mail.gmail.com>
Date: Wed, 5 Nov 2008 22:02:58 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Theodore Tso" <tytso@mit.edu>, "Yinghai Lu" <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.28-rc2: REGRESSION in early boot
In-Reply-To: <20081106052340.GA12762@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104224510.GA7672@mit.edu>
	 <86802c440811041614i5ab5e7f5hf910211ef57423e7@mail.gmail.com>
	 <20081105153508.GB22998@mit.edu>
	 <86802c440811050922o53f494c6y7b007f094a6ece2e@mail.gmail.com>
	 <20081106052340.GA12762@mit.edu>
X-Google-Sender-Auth: f93a4a3c35dda181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 9:23 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Nov 05, 2008 at 09:22:38AM -0800, Yinghai Lu wrote:
>> > What is your theory for why this was causing a failure in the timer
>> > subsystem?  Were we overrunning the end of irq_desc array and stomping
>> > on some other data structure?
>>
>> Yes. Please do apply that two patches at first.
>>
>
> Success!  Applying these two patches, as found at:
>
>        http://lkml.org/lkml/2008/11/4/431
>        http://lkml.org/lkml/2008/11/5/81
>
> ... and my 2.6.28-rc3-git2 based kernel successfully booted on my
> system.
>
> I'll update:  http://bugzilla.kernel.org/show_bug.cgi?id=11951
> accordingly.   Are these two patches scheduled to be pushed to
> mainstream, hopefully ASAP since they are a regression fix?

thanks.

Ingo, please check those two patches.

YH
