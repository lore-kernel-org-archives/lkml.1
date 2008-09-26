Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYIZFrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYIZFrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYIZFrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:47:09 -0400
Received: from blaine.gmane.org ([80.91.229.8]:37947 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYIZFrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:47:08 -0400
Message-ID: <48DC774C.3070800@yahoo.com>
Date: Fri, 26 Sep 2008 06:46:52 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Alan Jenkins 
	<public-alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@hugh.gmane.org>
CC: Pascal Terjan 
	<public-pterjan-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
       public-acpi4asus-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@hugh.gmane.org,
       Sitsofe Wheeler 
	<public-sitsofe-/E1597aS9LQAvxtiuMwx3w@hugh.gmane.org>,
       linux-kernel 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Subject: Re: Turning off camera also kills card reader on  EeePC 900 (USB
 regression?)
References: <48CE217A.1080409@tuffmail.co.uk> <48CE52EC.9060505@yahoo.com>		<48CE650B.6000708@tuffmail.co.uk>	<e8ca35370809251327x19dd4731n18aafc6ca4f40d70@mail.gmail.com> <48DC00C9.9070106@tuffmail.co.uk>
In-Reply-To: <48DC00C9.9070106@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 43d5474fe52f993f1d98170b32b30797
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alan Jenkins wrote:
> Pascal Terjan wrote:
>> On Mon, Sep 15, 2008 at 3:37 PM, Alan Jenkins
>> <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org> wrote:
>>   
>>> Sitsofe Wheeler wrote:
>>> The "HC died" message is interesting.  Sounds like the controller for
>>> these two USB devices stops working.  Maybe try unloading and reloading
>>> the ehci module?  I don't think I can help any more though.
>>>     
>> The issue also exist on 701 on 2.6.27-rc7 so the regression is in the
>> kernel not in the hardware
>>   
> On the bright side, that means more people should have the hardware to 
> test it on (including me :-).
> 
> I've certainly used the camera enable/disable at some point.  But I 
> could have missed the error message, and frankly I don't use the camera 
> or cardreader very often.  I'll have a bash at it tomorrow.
> 
> Sitsofe says it reproduced on kernel.org 2.6.21 (presumably with an 
> out-of-tree eeepc module).  So I guess this isn't a simple git-bisect 
> job - more thinking required...

Er turns out I might be mistaken wrt to 2.6.21. I do have a 2.6.21 
kernel but it turned out I don't have an eeepc/asus-acpi module. As I'm 
going away for the next few days I won't have an opportunity to test 
this soon.

The problem also seems to have vanished in Ingo's linux-tip ...

-- 
Sitsofe | http://sucs.org/~sits/

