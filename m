Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYGVSWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYGVSWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYGVSWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:22:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44368 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYGVSWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:22:06 -0400
Message-ID: <48862526.7060704@zytor.com>
Date: Tue, 22 Jul 2008 14:21:26 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
 boot
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>	 <48848DDF.6010903@zytor.com>	 <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>	 <48851AC2.8030007@zytor.com> <43e72e890807212147p5d19cfact17e719abb338378c@mail.gmail.com> <488614A3.1060400@garzik.org>
In-Reply-To: <488614A3.1060400@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>
>> Thanks for taking a  look at this. So well, it would be a
>> misconfiguration bug by the distribution then to try to support a
>> generic 686 kernel wihtout GENERIC then.
> 
> Well, it may be intentional -- some distros simply exclude support for 
> the lower-volume VIA processors, since that might imply building their 
> "generic 686 kernel" sans CMOV and some other instructions, and changing 
> the compiler's instruction scheduling to something less optimal for the 
> majority.  :/
> 

X86_GENERIC shouldn't disable CMOV?

We're only referring specifically to the family == 6 VIA processors here.

	-hpa

