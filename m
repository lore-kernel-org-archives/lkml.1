Return-Path: <linux-kernel-owner+w=401wt.eu-S937103AbXFGVm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937103AbXFGVm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934830AbXFGVmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:42:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:40442 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934638AbXFGVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=EoPdcp314kMDV250HEvSVd1apJvfSQT3/sn8ssC4QZbEV1I8ykyHOa+w/53pqPQ58jpmLlR1LbbeMV1R2IJrhO0BIXhYjzdlr1EoXZtINyt1UZxOFUDMRMT4tU3StJjy03S7mj1DRubNE7nEJTYjy36ZJEQDbRVANQkPah4faLk=
Message-ID: <46687BD3.1020603@gmail.com>
Date: Thu, 07 Jun 2007 23:42:43 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Joel.Becker@oracle.com
CC: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: ThinkPad T41 - Strange USB 2.0 behaviour
References: <46686937.9050306@gmail.com> <20070607205015.GD6528@ca-server1.us.oracle.com>
In-Reply-To: <20070607205015.GD6528@ca-server1.us.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker wrote:
> On Thu, Jun 07, 2007 at 10:23:19PM +0200, Robert de Rooy wrote:
>   
>> On my ThinkPad T41 USB 2.0 behaves strange. Most USB 2.0 devices, refuse 
>> to function as such. Under Windows I get a message that I should plug 
>> the device into a USB 2.0 port (but it continues to function as USB 
>> 1.1), while under Linux I need to manually unload ehci-hcd before I can 
>> access the device.
>>
>> The strange thing is that these USB 2.0 devices used to work just fine, 
>> and still do on other machines. In addition I have one USB 2.0 memory 
>> key that still works fine (both under Windows and Linux).
>>
>> Now to be honest, I think this is a hardware problem, as I have had 
>> another T41p before that also suddenly no longer liked USB 2.0 devices, 
>> and if you search with Google you find other ThinkPad T41 users 
>> complaining about similar behaviour.
>>     
>
> 	Hardware problem.  You need a new system board.  I had this
> problem on my T41, devices would sometimes work, sometimes not
> (depending on the reboot).  If I plugged in a USB 1.1 hub, then pluged
> the memory reader into the hub, it would always work at 1.1 speeds.
> 	New system board, USB 2.0 works just fine.
>
> Joel
>   
Yes I figured it was a hardware problem, but that was not really the 
point I was trying to raise ;). I would like, if possible for Linux to 
automatically fallback to USB 1.1 like Windows does (preferably with a 
suitable warning).

Regarding getting the systemboard replaced, this machine is already 
scheduled for replacement, and I should be getting a new one in the next 
few weeks. But other users apparently have been having similar problems, 
and might not want to get the (presumably out-of-warranty) systemboard 
replaced.
