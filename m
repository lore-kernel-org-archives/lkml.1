Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYCLSX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYCLSX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYCLSXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:23:19 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:45295 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbYCLSXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:23:18 -0400
X-Greylist: delayed 687 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2008 14:23:17 EDT
Message-ID: <47D81CD9.6000802@nortel.com>
Date: Wed, 12 Mar 2008 12:11:37 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803102050.40567.phillips@phunq.net> <20080312131133.60e99d29@the-village.bc.nu> <200803121029.54108.phillips@phunq.net>
In-Reply-To: <200803121029.54108.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2008 18:11:40.0440 (UTC) FILETIME=[8518F980:01C8846C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Wednesday 12 March 2008 06:11, Alan Cox wrote:

>>No I get that. You've ignored the fact I'm suggesting that design choice
>>is dumb.
> 
> 
> You seem to be calling Linux unreliable.

It's more reliable than many others, but it's not perfect.

Besides, there are many failure modes beyond the control of the kernel. 
  Hardware errors can lock up the bus and prevent I/O, RAM modules can 
go bad, technicians can yank out cards without waiting for the ready 
light.

For certain classes of devices it's necessary to plan for these sorts of 
things, and a model where the on-disk structures may be inconsistent by 
design is not going to be very attractive.

Chris
