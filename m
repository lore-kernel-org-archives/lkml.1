Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZKLLil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZKLLil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZKLLil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:38:41 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43227 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbZKLLik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:38:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        b=mTZbh4PB6u16mh2m2uxdfcdtk2wV5yzl6sUcZ/jp1eWmfg1N4cxTxXpoES+7Jnekrx
         spsvYsHfThOrPBx7n7eVsD3g6RrwPl7XWjvNsoUw971LbAzJO0Wus8vIEjZOB1HZF4l6
         Ek1jjtrTQ+bBK0d5PY20AKwVBLPhxV5CrLds0=
Date: Thu, 12 Nov 2009 11:38:36 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Caleb Cushing <xenoterracide@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: large packet loss take2 2.6.31.x
Message-ID: <20091112113836.GA7963@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81bfc67a0911111448q2e7938fcq18adf2454d6bc8f1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-2009 23:48, Caleb Cushing wrote:
> On Wed, Nov 11, 2009 at 5:05 PM, Frans Pop <elendil@planet.nl> wrote:
>> On Wednesday 11 November 2009, Andi Kleen wrote:
>>> Caleb Cushing <xenoterracide@gmail.com> writes:
>>>>> I'm attaching the bisection log and a 'good' dmesg output.
>>>>>
>>>>> c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9 is the first bad commit
>>> Just gives fatal: bad object c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9
>>> here on a standard Linus linux-2.6 tree.
>> Looks to be a commit from a stable update:
>>
>> commit c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9
>> Author: Alan Stern <stern@rowland.harvard.edu>
>> Date: Â  Tue Sep 1 11:38:34 2009 -0400
>>
>> Â  Â usb-serial: change referencing of port and serial structures
>>
>> Â  Â commit 41bd34ddd7aa46dbc03b5bb33896e0fa8100fe7b upstream.
>>
>> Cheers,
>> FJP
>>
> 
> yeah it is. it's from greg kroah-hartman's tree.

Could you answer the previous question too:

On 11-11-2009 22:47, Andi Kleen wrote:
...
> It might be also useful if you could describe what kind
> of network devices you use and how you determine
> the packet loss.

Btw, you didn't send the stats you compared, and your wireshark dump
doesn't show anything wrong either.

Jarek P.
