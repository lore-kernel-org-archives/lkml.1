Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZF0ES1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZF0ES1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 00:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbZF0ESS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 00:18:18 -0400
Received: from mail.anarazel.de ([217.115.131.40]:34426 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZF0ESS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 00:18:18 -0400
Message-ID: <4A459D85.2080008@anarazel.de>
Date: Sat, 27 Jun 2009 06:18:13 +0200
From: Andres Freund <andres@anarazel.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090625 Shredder/3.0b3pre
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alexander Chiang <achiang@hp.com>
CC: Thomas Renninger <trenn@suse.de>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [BUG] GM45 blanks shortly after boot in 2.6.30-git
References: <4A43359F.3030208@anarazel.de>
In-Reply-To: <4A43359F.3030208@anarazel.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2009 10:30 AM, Andres Freund wrote:
> Hi,
>
> Somewhere between:
> 03347e2592078a90df818670fddf97a33eec70fb (2.6.30 + 5415 commits)
> and
> c82e6d450fda56cb2d4f68534173d3cd11b32f9f (2.6.30 + 8722 commits)
> my Laptop (Lenovo T500) with an Intel GM45 graphics card blanks display
> during boot (before starting with initramfs) , stops responding to
> anything (i.e. no caps-lock light) and shows no further activity (i.e.
> no hdd activity).
>
> Before the blank I did not see any sign of a backtrace or similar, but
> its hard to say there wasn't any. Unfortunately atm I don't have another
> computer nearby, so I could not get a network console output yet.
>
> If you don't have a quick idea I will either get nearby another computer
> to get a trace or start bisecting.
I have not yet had access to another computer (so no trace yet) but I 
bisected it to this very innocent looking commit:
1e4cffe78e1decd937c7b78410eec87da6b87954 : ACPI: video: convert to 
acpi_get_pci_dev

Hope I added the correct CC's

Andres

PS: bad Headache + no tiredness is a good combination to do bisecting ;-)
