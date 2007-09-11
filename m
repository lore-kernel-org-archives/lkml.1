Return-Path: <linux-kernel-owner+w=401wt.eu-S1763474AbXIKLl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763474AbXIKLl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXIKLlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:41:52 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:45688 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752560AbXIKLlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:41:51 -0400
Message-ID: <46E67EFD.2040902@grupopie.com>
Date: Tue, 11 Sep 2007 12:41:49 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] video: uvesafb: Add X86 dependency.
References: <20070911081752.GA19495@linux-sh.org>
In-Reply-To: <20070911081752.GA19495@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> uvesafb is x86-specific, reflect that in the Kconfig.

Hummm... uvesafb _shouldn't_ be x86 specific. At least according to 
their page [1] where it says: "works on non-x86 systems".

Uvesafb uses a x86 emulator in userspace to run code from the video card 
ROM, so it should work on any PCI system where we can access the video 
card ROM and can emulate the hardware used by the ROM code.

Why do you say that it's x86 specific? Am I missing something?

-- 
Paulo Marques - www.grupopie.com

"You're just jealous because the voices only talk to me."

[1] http://dev.gentoo.org/~spock/projects/uvesafb/
