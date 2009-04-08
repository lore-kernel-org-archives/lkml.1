Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZDHWKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZDHWKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZDHWKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:10:42 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:50558 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbZDHWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:10:41 -0400
Message-ID: <49DD20DA.3020902@nortel.com>
Date: Wed, 08 Apr 2009 16:10:34 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: linux-kernel@vger.kernel.org,
       Linux Network Development list <netdev@vger.kernel.org>
Subject: Re: dhcp-based netboot over jumbo-frame network?
References: <49DCE470.9060109@nortel.com> <49DCF7E2.2060304@hp.com>
In-Reply-To: <49DCF7E2.2060304@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2009 22:10:36.0287 (UTC) FILETIME=[D7DBA0F0:01C9B896]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Jones wrote:
> Chris Friesen wrote:

>> We have an existing system that loads a bare kernel using tftp, then 
>> mounts a rootfs via NFS.  The wrinkle is that this is on a jumbo-frame 
>> enabled network, so somehow the MTU needs to be set before mounting the 
>> rootfs.
> 
> Why?  Is the NFS mount not TCP?  If it is TCP, then the TCP MSS exchange will 
> provide you cover as it will (should) cause TCP in the NFS server to segment to 
> the MSS option your system with the then-smaller MTU sends.
> 
> I would think that only if the NFS mount is UDP that you would have a problem 
> with the system initially booting with a small MTU.

Currently it uses the default, which is udp.  I might be able to get 
them to try TCP.  Thanks for the suggestion.

>> In a previous version we patched ipconfig.c to support the DHCP option 
>> to specify the MTU value, but I'm wondering about the "proper" way to do 
>> this on current kernels.
> 
> Was the change submitted to upstream and rejected?

The change was submitted (not by us) back in the 2.6.10 timeframe, and 
was rejected with the suggestion to use initramfs.

Chris
