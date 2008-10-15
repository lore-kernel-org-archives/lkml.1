Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYJOJmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYJOJmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYJOJmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:42:03 -0400
Received: from styx.suse.cz ([82.119.242.94]:39720 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752056AbYJOJmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:42:02 -0400
Date: Wed, 15 Oct 2008 11:42:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [GIT] HID patches for 2.6.28
In-Reply-To: <20081015093636.GB19403@elte.hu>
Message-ID: <alpine.LNX.1.10.0810151139200.26779@jikos.suse.cz>
References: <alpine.LNX.1.10.0810140055060.26779@jikos.suse.cz> <alpine.LNX.1.10.0810150011280.26779@jikos.suse.cz> <20081015093636.GB19403@elte.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Ingo Molnar wrote:

> this or the I2C updates cause widespread build failures in latest -git:

For the usbhid_set_leds(), Adrian has already sent me a fix [1]. Still, I 
would like to understand whether this failure is bug or feature in 
select/depends handling in Kconfig, because it seems to behave differently 
from what I was expecting.

But I have Adrian's patch in my tree and will be sending pull request to 
Linus today, after I sort a few more pending things up.

[1] http://lkml.org/lkml/2008/10/15/24

Thanks,

-- 
Jiri Kosina
