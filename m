Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbXEFRSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbXEFRSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 13:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbXEFRSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 13:18:17 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:22348 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbXEFRSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 13:18:16 -0400
Date: Sun, 06 May 2007 11:18:11 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: select-like implementation for kernel sockets
In-reply-to: <1178449075.942407.164040@q75g2000hsh.googlegroups.com>
To: eitanr@audiocodes.com, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <463E0DD3.9050909@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1178449075.942407.164040@q75g2000hsh.googlegroups.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

eitanr@audiocodes.com wrote:
> Hi,
> 
> I'm using kernel sockets to Tx and Rx UDP packets between my hardware
> device (DSP) to the external network (this is part of a VoIP
> implementation). The motivation for using kernel sockets rather than
> user-space sockets is to avoid the copying of data between kernel and
> user spaces.

I think we are zero-copy in many cases for UDP these days, so this 
doesn't necessarily buy you anything..

> 
> I have no problems on the Tx side (I simply call sock_sendmsg on one
> of the sockets), but for the Rx side I want to listen-in on multiple
> sockets in blocking mode (I don't want to use polling).
> 
> Is there a way to listen-in on multiple kernel sockets from one kernel
> thread? In the user space I would have used select(), but I am not
> familiar with a similar solution for the kernel space.
> 
> Thanks,
> Eitan.
> 
> Eitan Richardson
> AudioCodes Ltd.
> 

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

