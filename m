Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYKEPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYKEPOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 10:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYKEPOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 10:14:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:44412 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbYKEPOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 10:14:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,550,1220252400"; 
   d="scan'208";a="356497342"
Message-ID: <4911B829.8040701@linux.intel.com>
Date: Wed, 05 Nov 2008 07:13:45 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bernhard Schmidt <berni@birkenwald.de>
CC: Yves-Alexis Perez <corsac@debian.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, "Carlos R. Mafra" <crmafra2@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Long delays and keystrokes required - related to disk	encryption?
References: <20081105020340.GA6399@schleppi.birkenwald.de>
In-Reply-To: <20081105020340.GA6399@schleppi.birkenwald.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Schmidt wrote:
> In gmane.linux.kernel, Yves-Alexis Perez wrote:
> 
>> On Mon, Nov 03, 2008 at 08:23:27AM +0100, Yves-Alexis Perez wrote:
>>> FTR, it seems fixed in 2.6.28-rc3 (I just git pull-ed the tree, so I
>>> don't know which commit has fixed the problem)
>>>
>>> Could anyone (Frans?) confirm this?
>> Hmhm ok, it's *not* fixed, it just appears a bit better, but it's
>> still slow and hangs during boot process until I type some random
>> keys.
> 
> I can confirm that (unfortunately).
> 
> Dell Latitude D630 amd64, Ubuntu Intrepid (8.10), unencrypted ext4 root
> and encrypted (dm-crypt) ext4 /home.


I assume that if you add that return it also works?
(if not you have a totally unrelated issue)

one request to the folks on the mail who know it's fixed by the return;
can you send me your .config and dmesg and name of the machine?
(eg vendor/model)
I'm failing to reproduce and would like to get as exactly the same as you guys as possible...
