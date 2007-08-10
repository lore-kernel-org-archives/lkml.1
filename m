Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbXHJLFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbXHJLFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762189AbXHJLFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:05:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:4699 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760948AbXHJLFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HGnYtO4x2TemQCkDETslyTsy3qpPxHhfQEKPrtc0saFA5yJiynZqkhJXtBEB1qSTYBQmxe47a4HAwnrtdqcX26UdxbexI2zc9kGbsaaRl8ki0374rS5Avc/UtEe1pobHbT14Ws6yiLSQNDrVl4QiKeGJJHFhaQn/kZ87/cRqQ6k=
Message-ID: <46BC45FA.7060305@googlemail.com>
Date: Fri, 10 Aug 2007 13:03:22 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org> <46BC3CB1.2090503@googlemail.com>
In-Reply-To: <46BC3CB1.2090503@googlemail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> ...
> 
>> +sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
>> +sysctl-factor-out-sysctl_data.patch
>> +sysctl-error-on-bad-sysctl-tables.patch
>> +sysctl-update-sysctl_check_table.patch
>> +sysct-mqueue-remove-the-binary-sysctl-numbers.patch
>> +sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
>> +sysctl-fix-neighbour-table-sysctls.patch
>> +sysctl-ipv6-route-flushing-kill-binary-path.patch
>> +sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
>> +sysctl-x86_64-remove-unnecessary-binary-paths.patch
>> +sysctl-remove-broken-cdrom-binary-sysctls.patch
>> +sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
>> +sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
>>
>>  sysctl cleanups
>>
> 
> ...
> 
> 
> Getting all this on boot :
> 
> ...
> 
> [  484.984331] sysctl table check failed: /dev/parport/default/timeslice .7.3.-3.1 Missing strategy
> [  484.984515] sysctl table check failed: /dev/parport/default/spintime .7.3.-3.2 Missing strategy
> [  485.001254] sysctl table check failed: /dev/parport/parport0/devices/Device ID probe .7.3.1.6.1 Directory with extra1
> [  485.001472] sysctl table check failed: /dev/parport/parport0/devices/Device ID probe/timeslice .7.3.1.6.1.1 Missing strategy
> [  485.042786] sysctl table check failed: /dev/parport/parport0/devices/Device ID probe .7.3.1.6.1 Directory with extra1
> [  485.042962] sysctl table check failed: /dev/parport/parport0/devices/Device ID probe/timeslice .7.3.1.6.1.1 Missing strategy
> [  485.083586] sysctl table check failed: /dev/parport/parport0/spintime .7.3.1.1 Missing strategy
> [  485.083731] sysctl table check failed: /dev/parport/parport0/base-addr .7.3.1.2 Missing strategy
> [  485.083878] sysctl table check failed: /dev/parport/parport0/irq .7.3.1.3 Missing strategy
> [  485.084022] sysctl table check failed: /dev/parport/parport0/dma .7.3.1.4 Missing strategy
> [  485.084166] sysctl table check failed: /dev/parport/parport0/modes .7.3.1.5 Missing strategy
> [  485.084317] sysctl table check failed: /dev/parport/parport0/devices .7.3.1.6 Directory with extra1
> [  485.084470] sysctl table check failed: /dev/parport/parport0/devices/active .7.3.1.6.-3 Missing strategy
> [  485.084653] sysctl table check failed: /dev/parport/parport0/autoprobe .7.3.1.16 Missing strategy
> [  485.084806] sysctl table check failed: /dev/parport/parport0/autoprobe0 .7.3.1.17 Missing strategy
> [  485.084954] sysctl table check failed: /dev/parport/parport0/autoprobe1 .7.3.1.18 Missing strategy
> [  485.085103] sysctl table check failed: /dev/parport/parport0/autoprobe2 .7.3.1.19 Missing strategy
> [  485.085253] sysctl table check failed: /dev/parport/parport0/autoprobe3 .7.3.1.20 Missing strategy
> [  485.114655] sysctl table check failed: /dev/parport/parport0/devices/lp .7.3.1.6.1 Directory with extra1
> [  485.114856] sysctl table check failed: /dev/parport/parport0/devices/lp/timeslice .7.3.1.6.1.1 Missing strategy
> 
> ....
> 
> 



And this 2

...
[   30.046491] sysctl table check failed: /kernel/cad_pid .1.54 Missing strategy
[   30.046527] sysctl table check failed: /kernel/pty/nr .1.62.2 No data
...
 
