Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbXFGOFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbXFGOFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbXFGOFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:05:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:5434 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbXFGOFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Rs/T7UVugm+KO1/y73al1d0CB9Tvlx7nrX8539bZGtLcyVmPmZ7nSUhqhEb6b6XxE5Ut0X4DXdSKHWD9FdawELEJboqKUyFNOQFsiecYEthb4Pf94WRNYN1h6qH8fYnm9d1nIxvHQj2lc1ZriTD8POl/48Ky7ufi2yw6D7DiIg4=
Message-ID: <46681094.4070103@gmail.com>
Date: Thu, 07 Jun 2007 23:05:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: Duane Griffin <duaneg@dghda.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <46608E3F.4060201@dgreaves.com> <46609FAD.7010203@dgreaves.com>	 <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com>	 <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org>	 <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com>	 <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com>	 <4667DE2D.6050903@dgreaves.com> <e9e943910706070645p29519138i7e76b3a9649d387@mail.gmail.com> <46680F69.60105@dgreaves.com>
In-Reply-To: <46680F69.60105@dgreaves.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> Duane Griffin wrote:
>> On 07/06/07, David Greaves <david@dgreaves.com> wrote:
>>> > How hard does the machine freeze?  Can you use sysrq?  If so, please
>>> > dump sysrq-t.
>>> I suspect there is a problem writing to the consoles...
>>>
>>> I recompiled (rc4+patch) with sysrq support, suspended, resumed and
>>> tried
>>> sysrq-t but got no output.
>>>
>>> I *can* change VTs and see the various login prompts, bitmap messages
>>> and the
>>> console messages. Caps/Num lock lights work.
>>>
>>> Fearing incompetence I tried sysrq-s sysrq-u sysrq-b and got a reboot
>>> so sysrq
>>> is OK.
>>
>> Try sysrq-9 before the sysrq-t. Probably the messages are not being
>> printed to console with your default output level.
> 
> Good idea :)
> Didn't work :(

Can you setup serial console and/or netconsole (not sure whether this
would work tho)?

-- 
tejun
