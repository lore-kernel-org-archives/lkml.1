Return-Path: <linux-kernel-owner+w=401wt.eu-S1762809AbXIXTa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762809AbXIXTa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXIXTaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:30:16 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:34438 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbXIXTaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:30:14 -0400
Message-ID: <46F8101E.1050000@freescale.com>
Date: Mon, 24 Sep 2007 14:29:34 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Dan Malek <dan@embeddedalley.com>
CC: Jochen Friedrich <jochen@scram.de>, linux-kernel@vger.kernel.org,
       linuxppc-embedded@ozlabs.org
Subject: Re: [PATCH4/4] [POWERPC] Fix cpm_uart driver
References: <46F6C9DC.90008@scram.de> <46F7DE85.7000401@freescale.com> <46F7EE95.1040509@scram.de> <46F80049.2030509@freescale.com> <FF1A2486-BE77-49F8-99F3-B09B4EEAF50D@embeddedalley.com>
In-Reply-To: <FF1A2486-BE77-49F8-99F3-B09B4EEAF50D@embeddedalley.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Malek wrote:
> 
> On Sep 24, 2007, at 11:22 AM, Scott Wood wrote:
> 
>> cpmp is a physical address on arch/ppc?
> 
> No, it's a well known ioremaped() address into the IMMR space.

Maybe that's how it was, but the current code initializes it (more or
less) directly with IMAP_ADDR, which also gets fed into ioremap.

One of the two has got to be wrong.

-Scott
