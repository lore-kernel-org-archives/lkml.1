Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYKERWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYKERWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYKERWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:22:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:8407 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbYKERWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HQsHOgTXmrud564Rc/68TLoeXNDJiD4r45G5Fm2n3qgNI4WWWk/skkpcly8SU5M2m2
         K5fpR04LGTyxWgtZMiEse58+Dt8pbnKQV2QMeykh9pB3eii0GgaPrBdpAg7a8BM/XnIi
         hCrP1C8OuDg4i7W9pJ02OQBTtvIrZv6vaO1LM=
Message-ID: <86802c440811050922o53f494c6y7b007f094a6ece2e@mail.gmail.com>
Date: Wed, 5 Nov 2008 09:22:38 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Theodore Tso" <tytso@mit.edu>, "Yinghai Lu" <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.28-rc2: REGRESSION in early boot
In-Reply-To: <20081105153508.GB22998@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104224510.GA7672@mit.edu>
	 <86802c440811041614i5ab5e7f5hf910211ef57423e7@mail.gmail.com>
	 <20081105153508.GB22998@mit.edu>
X-Google-Sender-Auth: 4c232b1f12eadfbd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 7:35 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Nov 04, 2008 at 04:14:14PM -0800, Yinghai Lu wrote:
>>
>> please check http://lkml.org/lkml/2008/11/4/431
>>
>
> So do you believe that applying this fix will address the failure I
> was seeing?  In a follow up to your thread you replyed to Ben
> Hurchings saying:
>
>>your patch is still needed...
>>also please add one WARN_ON when nr > NR_IRQS.
>>YH
>
> Is there some other patch I should look at as well?
>
> What is your theory for why this was causing a failure in the timer
> subsystem?  Were we overrunning the end of irq_desc array and stomping
> on some other data structure?

Yes. Please do apply that two patches at first.

YH
