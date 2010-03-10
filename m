Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0CJPqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:46:38 -0500
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:55107 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab0CJPqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:46:37 -0500
Message-ID: <4B97BEA7.8010804@inf.tu-dresden.de>
Date: Wed, 10 Mar 2010 16:45:43 +0100
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100217 Shredder/3.0.3pre
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Evan McClain <evan.mcclain@gatech.edu>, rpurdie@rpsys.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: mbp_nvidia_bl - add five more MacBook	variants
References: <1268180458-1844-1-git-send-email-evan.mcclain@gatech.edu> <20100310142424.GA21625@srcf.ucam.org>
In-Reply-To: <20100310142424.GA21625@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10.03.2010 15:24, Matthew Garrett wrote:
> Acked in principle, but at this point it probably needs to be renamed
> and have the Kconfig entry updated if it's going to be used for other
> hardware. Does it actually work on non-nvidia Macs?

I assume you mean non-Nvidia chipset. Yes, it works, because the driver
uses the firmware interface. This is what Apple's Windows (bootcamp) drivers
do as well.

Tested using a simple program that writes the ports from userland.
And ack: it should probably be renamed to something more reasonable.
Something like apple_bl?

ciao,
Mario
