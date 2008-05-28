Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbYE1O5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbYE1O5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYE1O5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:57:39 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:58180 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYE1O5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:57:38 -0400
Message-ID: <483D729B.1000706@linux.vnet.ibm.com>
Date: Wed, 28 May 2008 20:26:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: MPTSAS problems in 2.6.26-rc2-mm1
References: <483D28C5.4060406@linux.vnet.ibm.com> <1211967958.12349.65.camel@twins> <1211986063.3445.18.camel@localhost.localdomain>
In-Reply-To: <1211986063.3445.18.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2008-05-28 at 11:45 +0200, Peter Zijlstra wrote:
>> On Wed, 2008-05-28 at 15:11 +0530, Balbir Singh wrote:
>>> I have 2.6.26-rc2-mm1 with Rik's splitvm patches. While booting the kernel, I
>>> ran into the following. I searched my email quickly to see that no one else has
>>> reported this problem. Lockdep seems to be complaining about the same lock being
>>> held at the same location (the message is a bit confusing to me).
>> looks like device_add() recursing - most likely with a different device
>> though.
> 
> This is another instance of a problem being caused by semaphore to mutex
> conversion in struct class;
> 
> There's another thread on this here:
> 
> http://marc.info/?t=121074904600001

Thanks for pointer, it does indeed look like a variant of the same problem

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
