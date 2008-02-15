Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbYBOCgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbYBOCgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 21:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbYBOCgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 21:36:32 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:45216 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764051AbYBOCgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 21:36:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VDENS3D2UUI7DeS7wZLzos8JoIYgzlfWo8IbhVvdCupPxJlKAdKEY3nH8uPcuDYk70toUX+le/Uhbi0KXy0sz5tBObYCQiY1/bMMephT7Zu7K3nAEdmJEFWzaK4EpslZ/brmhjgJR/U4+W8PHDtRV2O2nbYzfRadmR/aYwAIMA4=
Message-ID: <47B4FA9C.9080809@gmail.com>
Date: Fri, 15 Feb 2008 11:36:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk,
 take #3
References: <12028937731333-git-send-email-htejun@gmail.com>	<20080213155701.48871761.akpm@linux-foundation.org>	<47B38E13.1060503@gmail.com>	<20080213170950.86945835.akpm@linux-foundation.org>	<47B398B3.40308@gmail.com>	<47B4EFAB.2040102@gmail.com> <20080214182700.a9a706e9.akpm@linux-foundation.org>
In-Reply-To: <20080214182700.a9a706e9.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>> printk is a special case, I think.  It's the primary logging/debugging
>>> method which can't fail and as it's mostly interpreted by human beings
>>> (and developers in problematic cases), it has different maneuvering room
>>> on errors - ie. it's far better to print messages w/o header or proper
>>> log level than failing to print, which is quite different requirements
>>> from other components.
>> Andrew, any more comments or suggestions on how to proceed on this?
> 
> Nope.
> 
>>  One
>> way or the other, I think this is a problem worth solving.
> 
> There are a lot of such problems ;)

So, I guess it's NACK w/o suggested alternatives, right?

-- 
tejun
