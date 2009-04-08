Return-Path: <linux-kernel-owner+w=401wt.eu-S1764916AbZDHTQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764916AbZDHTQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZDHTPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:15:52 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:38102 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZDHTPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:15:51 -0400
Message-ID: <49DCF7E2.2060304@hp.com>
Date: Wed, 08 Apr 2009 12:15:46 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: linux-kernel@vger.kernel.org,
       Linux Network Development list <netdev@vger.kernel.org>
Subject: Re: dhcp-based netboot over jumbo-frame network?
References: <49DCE470.9060109@nortel.com>
In-Reply-To: <49DCE470.9060109@nortel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> 
> Hi all,
> 
> We have an existing system that loads a bare kernel using tftp, then 
> mounts a rootfs via NFS.  The wrinkle is that this is on a jumbo-frame 
> enabled network, so somehow the MTU needs to be set before mounting the 
> rootfs.

Why?  Is the NFS mount not TCP?  If it is TCP, then the TCP MSS exchange will 
provide you cover as it will (should) cause TCP in the NFS server to segment to 
the MSS option your system with the then-smaller MTU sends.

I would think that only if the NFS mount is UDP that you would have a problem 
with the system initially booting with a small MTU.

> In a previous version we patched ipconfig.c to support the DHCP option 
> to specify the MTU value, but I'm wondering about the "proper" way to do 
> this on current kernels.

Was the change submitted to upstream and rejected?

rick jones
