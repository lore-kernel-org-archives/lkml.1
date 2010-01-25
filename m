Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523Ab0AYXzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab0AYXzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126Ab0AYXzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:55:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761Ab0AYXzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:55:38 -0500
Date: Mon, 25 Jan 2010 15:54:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-Id: <20100125155410.1fde82d4.akpm@linux-foundation.org>
In-Reply-To: <20100118183435.948841000@alcatraz.americas.sgi.com>
References: <20100118183412.560438000@alcatraz.americas.sgi.com>
	<20100118183435.948841000@alcatraz.americas.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 12:34:14 -0600
Mike Travis <travis@sgi.com> wrote:

> @@ -717,4 +744,7 @@

Please use `diff -p'.

This is within `void __init uv_system_init(void)'

>  	uv_cpu_init();
>  	uv_scir_register_cpu_notifier();
>  	proc_mkdir("sgi_uv", NULL);
> +
> +	/* register Legacy VGA I/O redirection handler */
> +	pci_register_set_vga_state(uv_set_vga_state);
>  }

So pci_register_set_vga_state() could/should have been __init?
