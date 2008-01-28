Return-Path: <linux-kernel-owner+w=401wt.eu-S1764934AbYA1Xp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934AbYA1Xp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761574AbYA1Xpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:45:45 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:17845 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761993AbYA1Xpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:45:44 -0500
Date: Mon, 28 Jan 2008 17:47:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Blu Ray LG GGW-H20L crashes Linux
In-reply-to: <1201563794.3182.18.camel@fermat.scientia.net>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <479E699D.1090102@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.QKOfoC0jShKF1yDA3BpSsRBOQzY@ifi.uio.no>
 <479E677C.9070301@shaw.ca> <1201563794.3182.18.camel@fermat.scientia.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Anton Mitterer wrote:
> On Mon, 2008-01-28 at 17:38 -0600, Robert Hancock wrote:
>> Christoph Anton Mitterer wrote:
>>> btw: I'm cross posting this to lkml and debian-user,... hope nobody
>>> feels offended :-)
>> How much RAM is in your machine? There's a known problem with sata_nv 
>> ADMA with ATAPI devices and over 4GB of RAM.
> Uhm *tadaaa* ... got 4GB ^^
> Ok,.. so If this only applies to ATAPI devices it should be clear why my
> SATA HDDs aren't affected ;)
> 
>> As a temporary workaround, 
>> you can boot with sata_nv.adma=0 on the kernel command line, or limit 
>> your memory with the mem= command line option so that memory over 4GB is 
>> not used.
> Great,.. will have a try tomorrow :-)
> 
> Is this already fixed in git?

Nope, I/we are still trying to figure out how to fix this properly..
