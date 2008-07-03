Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYGCTQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYGCTQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYGCTP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:15:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39570 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYGCTP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:15:56 -0400
Message-ID: <486D2564.4030806@zytor.com>
Date: Thu, 03 Jul 2008 12:15:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Jens-Michael Hoffmann <J.Hoffmann@option.com>,
       linux-kernel@vger.kernel.org
Subject: Re: tcp/ip connect on demand
References: <F67862BE33DC784289A6B34E92908FCF393FFE@SRV-SATURNUS.OPTION.local> <486D1A66.6010006@zytor.com> <alpine.LNX.1.10.0807032106310.23294@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0807032106310.23294@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Thursday 2008-07-03 20:28, H. Peter Anvin wrote:
>> Jens-Michael Hoffmann wrote:
>>> hi,
>>>
>>> what is the right way to implement a "connect on demand" feature?
>>> Example: user types url in firefox and presses return. Then
>>> the system should set up network devices and proceed as usual.
>>>
>>> Is there a hook in the kernel we can use?
>> In the kernel, no.  Nor do you need one; the best place to hook into this is
>> probably the name service system (so you catch it on trying to look up
>> hostnames.)
>>
>> Alternatively, you can set up a bridge device which you can listen to via a tap
>> device; when you see traffic, you bring up the real network and attach it to
>> the bridge.
> 
> There is on-demand for PPP devices; though that is probably specific
> to PPP.

Yes, those monitor traffic at the PPP device port, I believe.

	-hpa
