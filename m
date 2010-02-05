Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab0BERYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:24:34 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:47449 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950Ab0BERYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:24:32 -0500
Message-ID: <4B6C53E9.8030802@oracle.com>
Date: Fri, 05 Feb 2010 12:22:49 -0500
From: Chuck Lever <chuck.lever@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: i915 oops on 2.6.33-rc6
References: <4B6B17D2.4090307@oracle.com> <20100205004236.GA10885@hexapodia.org>
In-Reply-To: <20100205004236.GA10885@hexapodia.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B6C5442.00AE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2010 07:42 PM, Andy Isaacson wrote:
> On Thu, Feb 04, 2010 at 01:54:10PM -0500, Chuck Lever wrote:
>> Pulled from Linus' git repo yesterday, and got this on a Dell Latitude
>> D620, on every boot since then.  Updated to latest a couple of hours
>> ago, and still seeing it.  kernel config and lspci output attached.
>>
>> I'm not subscribed to lkml, please ensure I'm in the cc: or to: field on
>> relevant replies.
>>
>>
>> Feb  4 13:17:43 monet kernel: [drm:i915_gem_do_execbuffer] *ERROR*
>> Invalid object handle 1073741824 at index 3
>
> This isn't quite the same symptom everyone else is seeing, but DRM
> having object handle problems makes me wonder if you're running into
>
> http://lkml.org/lkml/2010/2/3/415
> http://lkml.org/lkml/2010/2/3/463
>
> Does reverting 859ddf09743a8cc680af33f7259ccd0fd36bfe9d help?

Yes, GDM starts normally with that commit reverted.  No oops occurs, and 
the OS can reboot now without hanging at shutdown.

-- 
chuck[dot]lever[at]oracle[dot]com
