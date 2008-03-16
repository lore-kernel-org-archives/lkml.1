Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbYCPNJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYCPNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 09:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYCPNJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 09:09:48 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:46781 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYCPNJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 09:09:31 -0400
Date: Sun, 16 Mar 2008 14:08:41 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Chr <chunkeey@web.de>
cc: Milan Broz <mbroz@redhat.com>, David Chinner <dgc@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
       dm-crypt@saout.de
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120
 seconds
In-Reply-To: <200803152234.53199.chunkeey@web.de>
Message-ID: <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <200803150108.04008.chunkeey@web.de> <200803151432.11125.chunkeey@web.de> <200803152234.53199.chunkeey@web.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Mar 2008, Chr wrote:
> On Saturday 15 March 2008 14:32:10 Chr wrote:
>> reverted:
>>
>> commit  3a7f6c990ad04e6f576a159876c602d14d6f7fef
>> dm crypt: use async crypto
>>
>> dm-crypt: Use crypto ablkcipher interface
>> Move encrypt/decrypt core to async crypto call.
>>
>
> well.... it's much better now, without the async interface.
> Christian Kajau, can you confirm it too?

I reverted the commit above from today's -git and booted....I could not 
notice any hangs more. But when I tried to reproduce these hangs by 
generating disk I/O (mostly reads) ~10 minutes later the box panicked, but
still not netconsole messages :-(

thanks,
C.
-- 
BOFH excuse #233:

TCP/IP UDP alarm threshold is set too low.
