Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbZCSHSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbZCSHSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZCSHSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:18:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:33680 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZCSHSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qdG5pLvfZtSoJEzeBqeGT/t4lS5LabLIhkZzn8J7hdHSYFyWFCvnr96MRyThpaJKZc
         MuwA11P9VYrwWtfCS+7kAS0LkUp/97vd+scMPAmD0GIRb4LT8Go/ZIMiJ+OBPV/gRe0u
         8WyiAhT6d+Rbxu92PM1kw4FaFQ8J2D9kVXK9U=
MIME-Version: 1.0
In-Reply-To: <49C1EE7D.5070507@linux.intel.com>
References: <2a27d3730903172325w16ec329cp872ec35d100f6506@mail.gmail.com>
	 <200903190000.33572.rjw@sisk.pl> <49C1EE7D.5070507@linux.intel.com>
Date: Thu, 19 Mar 2009 15:18:27 +0800
X-Google-Sender-Auth: a7632c5f90bae2da
Message-ID: <2a27d3730903190018h1a0f5b6asf5cf2002fe3504fb@mail.gmail.com>
Subject: Re: nonboot cpu on SMP suspend
From: Li Yang <leoli@freescale.com>
To: chen gong <gong.chen@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 3:04 PM, chen gong <gong.chen@linux.intel.com> wrote:
> Rafael J. Wysocki 写道:
>>
>> On Wednesday 18 March 2009, Li Yang wrote:
>>>
>>> Hi all,
>>>
>>> I'm curious why we need to un-plug all the nonboot cpus before suspend
>>> and start them all over again after the suspend(ACPI sleep)?  I mean
>>> if we can bring the booting cpu back to the exact state as before
>>> suspend, why can't we just do the same for non-booting cpus?  And that
>>> will be much faster.  Any thought?  Thanks.
>>
>> Because we need to enter the BIOS with one CPU on-line only.
>>
> You mean only one CPU can be supported by BIOS when suspend/resume ?

If so, is it a defect of x86 BIOS?  And is it true that for other
architectures without a BIOS there won't be such a limitation if the
boot code is sane?  Thanks

- Leo
