Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbYEALMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbYEALMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 07:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbYEALMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 07:12:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:11339 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbYEALMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 07:12:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i463a1qooRen8fSGvpH4ZY6c9PLjqr91qoJzL4WcL2SL417HKFqJ22mDknK6ikYRU3f7hgSTXZh/cVIq4aiQc940bLUdj5VpFDq2pIQqDDT1DubfCaCLbRpC1/QGG4qom1w6lh6CzhJId8FP+RibOpg/ogbkP3f8+CHTktDpvk8=
Message-ID: <e2e108260805010412g2f69bc4dh7b639aab3f6fafcb@mail.gmail.com>
Date: Thu, 1 May 2008 13:12:20 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH 1/1] Embedded Maintainer(s), linux-embedded@vger list
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Tim Bird" <tim.bird@am.sony.com>
In-Reply-To: <1209636359.25560.512.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1209577322.25560.402.camel@pmac.infradead.org>
	 <1209577483.25560.405.camel@pmac.infradead.org>
	 <e2e108260805010255v6b728998i7d4952cc8fec28cb@mail.gmail.com>
	 <1209636359.25560.512.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 12:05 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Thu, 2008-05-01 at 11:55 +0200, Bart Van Assche wrote:
>> It's great that more attention is being paid to the use of Linux in
>> embedded systems. And the MAINTAINERS file is probably the right file
>> to add the above information. But I'm afraid that the way the above
>> information is formatted will cause confusion. As an example, recently
>> there was a driver added to the Linux kernel for the PCF8575 chip.
>> This is an I2C chip that is only used in embedded systems. Regarding
>> driver review, should any such drivers be sent to the I2C mailing
>> list, the embedded mailing list or both ? The MAINTAINERS file should
>> be clear on this.
>
> The I²C list would be the best place to send such a patch. You could
> also copy it to the linux-embedded list if it's likely to be of interest
> to a reasonable proportion of "embedded" developers, but that wouldn't
> be the primary route into Linus' tree for most things.
>
> I can't really see any way to make that clear in the MAINTAINERS file
> that wouldn't be clumsy and just as confusing -- I think it'll work out
> just fine by itself. Do you have a concrete proposal?

The information present in the current MAINTAINERS file is such that
given the name(s) of the source files affected by a patch, one can
look up the appropriate mailing list(s) and maintainer(s) to send the
patch to. Information about embedded maintainer(s) is different: it's
not about maintaining specific source files but about general
discussions with regard to kernel changes for embedded systems. Maybe
there should be two sections in the MAINTAINERS file, one for
maintainers of specific source trees and another section for
coordinators of specific usage scenario's of the Linux kernel ?

Bart.
