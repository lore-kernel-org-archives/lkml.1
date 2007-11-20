Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbXKTBFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbXKTBFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752405AbXKTBFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:05:33 -0500
Received: from smtpauth01.prod.mesa1.secureserver.net ([64.202.165.181]:33566
	"HELO smtpauth01.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752327AbXKTBFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:05:32 -0500
Message-ID: <474232D9.20407@seclark.us>
Date: Mon, 19 Nov 2007 20:05:29 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Power Saving
References: <47422D3B.8080704@seclark.us> <20071120005443.GB9243@redhat.com>
In-Reply-To: <20071120005443.GB9243@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:

>On Mon, Nov 19, 2007 at 07:41:31PM -0500, Stephen Clark wrote:
> > Hello List,
> > 
> > I am trying to get throttling to work on the following processor
>
>I think by throttling, you actually mean changing frequency/voltage ?
>(throttling is something else, where the CPU skips every n cycles,
> which doesn't actually save any power)
>
> > with linux 2.6.17-1.2142_FC4 with no luck.
>
>wow. that's a prehistoric kernel.
>
> > AMD Athlon(tm) XP 1700+
>
>you lose.  Only the mobile athlons supported scaling their speed.
>And even then, only if the BIOS supported it with the correct tables.
>(Typically this means, "only laptops").
>
>	Dave
>
>  
>
well what about the info from /proc/

cat /proc/acpi/processor/CPU0/info
processor id:            0
acpi id:                 0
bus mastering control:   no
power management:        yes
throttling control:      yes
limit interface:         yes

and:
cat /proc/acpi/processor/CPU0/throttling
state count:             2
active state:            T0
states:
   *T0:                  00%
    T1:                  50%

and:
[root@joker ~]# cat /proc/acpi/processor/CPU0/power
active state:            C2
max_cstate:              C8
bus master activity:     d18324c9
states:
    C1:                  type[C1] promotion[C2] demotion[--] 
latency[000] usage[01340140]
   *C2:                  type[C2] promotion[--] demotion[C1] 
latency[090] usage[02980043]

????
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



