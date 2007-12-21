Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbXLUTbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbXLUTbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 14:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXLUTbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 14:31:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbXLUTbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 14:31:22 -0500
Message-ID: <476C1472.1040103@redhat.com>
Date: Fri, 21 Dec 2007 14:30:58 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Filippos Papadopoulos <psybases@gmail.com>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>	 <20071217031841.f483e5ac.akpm@linux-foundation.org>	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>	 <47666904.8060605@panasas.com> <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
In-Reply-To: <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2007 03:48 AM, Filippos Papadopoulos wrote:
> On Dec 17, 2007 2:18 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> I have found one problem. Please try patch [2] below and report.
>> If it still fails try to enable debugging by setting with patch [1]
>> these values at top of drivers/scsi/initio.c. And send dmsgs.
>>
>> Boaz
>>
> 
> 
> I tried patch[2] (addition of   sg++)  at 2.6.24-rc5-mm1 but the
> system hangs after some seconds when the initio driver loads.
> I will try patch[1] next week to see what happens.
> 
> Would it be better to open a bug report at bugzilla?
> 

There is also a Fedora bug report against 2.6.23. The user has
applied commit e9e42faf47255274a1ed0b9bf1c46118023ec5fa from
2.6.24-rc plus the two additional fixes under discussion and it
hangs for him too.

https://bugzilla.redhat.com/show_bug.cgi?id=390531
