Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbZLAO5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbZLAO5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:57:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZLAO5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:57:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLAO5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:57:00 -0500
Message-ID: <4B152EA4.7080207@redhat.com>
Date: Tue, 01 Dec 2009 16:56:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Adam Litke <agl@us.ibm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
 (V4)
References: <1259597655.30369.2.camel@aglitke>
In-Reply-To: <1259597655.30369.2.camel@aglitke>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 06:14 PM, Adam Litke wrote:
> Changes since V3:
>   - Do not do endian conversions as they will be done in the host
>   - Report stats that reference a quantity of memory in bytes
>   - Minor coding style updates
>
> Changes since V2:
>   - Increase stat field size to 64 bits
>   - Report all sizes in kb (not pages)
>   - Drop anon_pages stat and fix endianness conversion
>
> Changes since V1:
>   - Use a virtqueue instead of the device config space
>
> When using ballooning to manage overcommitted memory on a host, a system for
> guests to communicate their memory usage to the host can provide information
> that will minimize the impact of ballooning on the guests.  The current method
> employs a daemon running in each guest that communicates memory statistics to a
> host daemon at a specified time interval.  The host daemon aggregates this
> information and inflates and/or deflates balloons according to the level of
> host memory pressure.  This approach is effective but overly complex since a
> daemon must be installed inside each guest and coordinated to communicate with
> the host.  A simpler approach is to collect memory statistics in the virtio
> balloon driver and communicate them directly to the hypervisor.
>
> This patch enables the guest-side support by adding stats collection and
> reporting to the virtio balloon driver.
>
>    

What about a spec update?  Did that happen and I just missed it?

-- 
error compiling committee.c: too many arguments to function

