Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZFBW4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZFBW4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbZFBW4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:56:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:36887 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbZFBW4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:56:08 -0400
Message-ID: <4A25ADB6.2070503@kernel.org>
Date: Tue, 02 Jun 2009 15:54:46 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pascal Terjan <pterjan@mandriva.com>
CC: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       stable <stable@kernel.org>, linux-pci@vger.kernel.org
Subject: Re: Stable regression 2.6.29.3 vs 2.6.29.2
References: <1243625720.4426.0.camel@plop>  <4A203BFD.7040000@kernel.org>	 <1243949325.19053.100.camel@plop>  <4A256050.2020305@kernel.org>	 <1243969741.27062.11.camel@plop>  <4A258F1C.7030707@kernel.org> <1243983068.1629.0.camel@plop>
In-Reply-To: <1243983068.1629.0.camel@plop>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pascal Terjan wrote:
> Le mardi 02 juin 2009 à 13:44 -0700, Yinghai Lu a écrit :
>> Pascal Terjan wrote:
>>> Le mardi 02 juin 2009 à 10:24 -0700, Yinghai Lu a écrit :
>>> ACPI: Using IOAPIC for interrupt routing
>>> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
>>> PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
>>> PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
>>> PCI: Using MMCONFIG for extended config space
>> please check
>>
>> [PATCH] x86/pci: fix mmconfig detection with 32bit need 4g
>>
> 
> I confirm that the machine boots fine with 2.6.29.4 + this patch

Thanks. Pascal

Can you try that on tip/master too?

http://people.redhat.com/mingo/tip.git/readme.txt

YH
