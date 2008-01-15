Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbYAOQQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbYAOQQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYAOQQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:16:24 -0500
Received: from mail.bigtelecom.ru ([87.255.0.61]:53309 "EHLO
	mail.bigtelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYAOQQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:16:23 -0500
X-Greylist: delayed 683 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 11:16:23 EST
Message-ID: <20080115190458.rxt3yhb2o8o404kc@mail.bigtelecom.ru>
Date: Tue, 15 Jan 2008 19:04:58 +0300
From: slavon@bigtelecom.ru
To: Frans Pop <elendil@planet.nl>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
References: <200801150625.10823.elendil@planet.nl>
	<20080114.215317.38045859.davem@davemloft.net>
	<200801151504.10047.elendil@planet.nl>
In-Reply-To: <200801151504.10047.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Frans Pop <elendil@planet.nl>:

> On Tuesday 15 January 2008, David Miller wrote:
>> From: Frans Pop <elendil@planet.nl>
>> > kernel: e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
>>
>> Does this make the problem go away?
>
> Yes, it very much looks like that solves it.
> I ran with the patch for 6 hours or so without any errors. I then switched
> back to an unpatched kernel and they reappeared immediately.
>
>> (Note this isn't the final correct patch we should apply.  There
>>  is no reason why this revert back to the older ->poll() logic
>>  here should have any effect on the TX hang triggering...)
>
> s/no reason/no obvious reason/ ? ;-)
>
> Cheers,
> FJP
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

Hello.

I also try your patch (apply to 2.6.24-rc7-git2)

I catch this message in dmesg
[ 1771.796954] e1000: eth1: e1000_clean_tx_irq: Detected Tx Unit Hang
[ 1771.796957]   Tx Queue             <0>
[ 1771.796958]   TDH                  <54>
[ 1771.796959]   TDT                  <54>
[ 1771.796960]   next_to_use          <54>
[ 1771.796961]   next_to_clean        <a9>
[ 1771.796962] buffer_info[next_to_clean]
[ 1771.796963]   time_stamp           <14d72e>
[ 1771.796964]   next_to_watch        <a9>
[ 1771.796965]   jiffies              <14ddd3>
[ 1771.796966]   next_to_watch.status <1>

Thanks.


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

