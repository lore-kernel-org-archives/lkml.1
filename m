Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbXHAOZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbXHAOZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbXHAOZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:25:25 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:14248 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXHAOZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:25:24 -0400
Date: Wed, 1 Aug 2007 15:24:28 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-pm@linux-foundation.org
Subject: Re: 2.6.21-rc1: T60 ACPI issues
In-Reply-To: <20070801135820.GA8266@mellanox.co.il>
Message-ID: <Pine.LNX.4.64.0708011516540.15447@blonde.wat.veritas.com>
References: <20070801135820.GA8266@mellanox.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAB2luYm94AGxpbnV4LWFjcGlAdmdlci5rZXJuZWwub3JnAGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAbWluZ29AcmVkaGF0LmNvbQBsaW51eC1wbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBsZW4uYnJvd25AaW50ZWwuY29tAG1pbmdvQGVsdGUuaHUAbXN0QGRldi5tZWxsYW5veC5jby5pbAA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007, Michael S. Tsirkin wrote:

> Hi!
> ACPI appears to have been broken with 2.6.23-rc1 on my T60
> Userspace from ubuntu dapper.

(Whereas I'm using a T43p with openSUSE 10.2.)

> 
> 1. During boot, I see a lot of messages like this:
> [   41.034204] acpi LNXSYSTM:00: uevent: unsupported action-string; this will be ignored in a future kernel version

(I've not seen those.)

> 
> 2. Pressing Fn/F4 does not trigger suspend to ram
>    This normally triigers ACPI event which triggers suspend to RAM on Ubuntu
>    (echo mem > /sys/power/state works)

I'll bet this is your CONFIG_THINKPAD_ACPI_INPUT_ENABLED=y.
I got the same, see my "THINKPAD_ACPI_INPUT_ENABLED seems regressive"
mail to Henrique and lkml an hour ago.

> 
> 3. After suspend to RAM, system wakes up but laptop's screen is blank,
>    switching VTs etc does not help.
>    External screen wakes up OK though.
>    dmesg output from boot attached.

(I've not had that.)

Hugh
