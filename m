Return-Path: <linux-kernel-owner+w=401wt.eu-S1762217AbYAKRxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217AbYAKRxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761489AbYAKRx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:53:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760707AbYAKRx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:53:26 -0500
Message-ID: <4787ACF1.7040501@redhat.com>
Date: Fri, 11 Jan 2008 12:52:49 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Filippos Papadopoulos <psybases@gmail.com>, linux-scsi@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>	 <47666904.8060605@panasas.com>	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>	 <476C1472.1040103@redhat.com>	 <1198271036.3130.60.camel@localhost.localdomain>	 <476C4177.3030902@redhat.com>	 <1198277391.3130.73.camel@localhost.localdomain>	 <9f00bd9d0801031618l324e9078i56b0679a35e27f69@mail.gmail.com>	 <1200028577.5337.8.camel@localhost.localdomain>	 <9f00bd9d0801110154i3b2f9c1flf076823747950196@mail.gmail.com> <1200066295.3286.19.camel@localhost.localdomain>
In-Reply-To: <1200066295.3286.19.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2008 10:44 AM, James Bottomley wrote:
>>> This proves the BAR0 to be non zero, but I also take it from your report
>>> that the
>>>
>>> initio: I/O port range 0x0 is busy.
>>>
>>> message is also gone?
>>>
>>
>> I havent reported "initio: I/O port range 0x0 is busy."
> 
> Sorry ... we appear to have several reporters of different bugs in this
> thread.  That message was copied by Chuck Ebbert from a Red Hat
> bugzilla ... I was assuming it was the same problem.
> 

Our reporter has applied patches since then and now reports the exact
same symptoms that Filippos does. (It just hangs after loading the driver.)
