Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYGYIyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYGYIyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYGYIyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:54:14 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:11210 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752712AbYGYIyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:54:13 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=i61rNrnOdaKKzolZ6X0A:9 a=09lU-PcosJvIWvJ5T93S5oaFQaUA:4 a=tNCvaO9EbNoA:10 a=CDgK0yFw8z8A:10
Message-ID: <488994AE.7040004@shaw.ca>
Date: Fri, 25 Jul 2008 02:54:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Tomas Styblo <tripie@cpan.org>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -	device
 152d:2338
References: <Pine.LNX.4.44L0.0807222238060.12003-100000@netrider.rowland.org> <4887BCB9.2000103@shaw.ca> <20080725084447.GA15483@notebook.homenet.local>
In-Reply-To: <20080725084447.GA15483@notebook.homenet.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Styblo wrote:
> * Robert Hancock <hancockr@shaw.ca> [Thu, 24 Jul 2008]:
>>>> Anyway, I'll send the patch to this person so he can try it. I guess it 
>>>> won't fix his problem. This patch is much simpler and doesn't need any 
>>>> delays - I really think this is a different situation.
>>> It isn't.  And your patch is an ad-hoc correction that doesn't address
>>> the true underlying reasons for the errors.
>> Tomas, you should try the patch listed in that bug report (well, except 
>> maybe the part that's actually adding the JMicron unusual devices entry) 
>> and see if that fixes the problem.
> 
> I'll try that patch next week - but I have no confidence in the
> reliability of fixing the problem by inserting random delays. All
> I have wanted to achieve is to detect the errors and thus prevent
> the silent data corruption. 
> 
> I don't really mind those sporadic forced resets since they cause
> no data corruption, at least in my setup. My simple patch
> accomplishes the goal of preventing data corruption more reliably,
> I think.

I agree, that's why I mentioned to leave out the part that adds the 
unusual devices entry which actually enables the random delays. There's 
another part of the patch which fixes underflow detection, which might 
have the same effect as your patch.
