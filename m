Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492Ab0AZAFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab0AZAFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323Ab0AZAFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:05:06 -0500
Received: from relay1.sgi.com ([192.48.179.29]:36592 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0AZAFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:05:05 -0500
Message-ID: <4B5E31AC.3060209@sgi.com>
Date: Mon, 25 Jan 2010 16:05:00 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Russ Anderson <rja@sgi.com>, Dave Airlie <airlied@redhat.com>,
       Alex Chiang <achiang@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robin Holt <holt@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adam Jackson <ajax@nwnk.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Gaetan Nadon <memsize@videotron.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       Aaron Plattner <aplattner@nvidia.com>, Jack Steiner <steiner@sgi.com>,
       Tiago Vignatti <tiago.vignatti@nokia.com>, Cliff Wickman <cpw@sgi.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Christian Zander <chzander@nvidia.com>, Yu Zhao <yu.zhao@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/4] x86_64 UV: Update UV arch to target Legacy VGA I/O
 correctly.
References: <20100118183412.560438000@alcatraz.americas.sgi.com>	<20100118183435.948841000@alcatraz.americas.sgi.com> <20100125155410.1fde82d4.akpm@linux-foundation.org>
In-Reply-To: <20100125155410.1fde82d4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 18 Jan 2010 12:34:14 -0600
> Mike Travis <travis@sgi.com> wrote:
> 
>> @@ -717,4 +744,7 @@
> 
> Please use `diff -p'.
> 
> This is within `void __init uv_system_init(void)'
> 
>>  	uv_cpu_init();
>>  	uv_scir_register_cpu_notifier();
>>  	proc_mkdir("sgi_uv", NULL);
>> +
>> +	/* register Legacy VGA I/O redirection handler */
>> +	pci_register_set_vga_state(uv_set_vga_state);
>>  }
> 
> So pci_register_set_vga_state() could/should have been __init?

Good catch.  Do you want me to update and resubmit?
