Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYKDQec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYKDQec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377AbYKDQeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:34:18 -0500
Received: from no-dns-yet.demon.co.uk ([80.176.108.50]:63633 "HELO
	mailgate.blueteddy.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1754720AbYKDQeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:34:17 -0500
X-Greylist: delayed 1011 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2008 11:34:15 EST
Message-ID: <49107543.5080207@blueteddy.net>
Date: Tue, 04 Nov 2008 16:16:03 +0000
From: Dave Hudson <linux-kernel@blueteddy.net>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev <netdev@vger.kernel.org>,
       Linux Networking <linux-net@vger.kernel.org>
Subject: Re: time for TCP ECN defaulting to on?
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
In-Reply-To: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
> Is it time to enable TCP ECN per default and get the benefits, since
> router support has been around and known-about for really considerable
> time?
> 
> Perhaps it should be a question of enabling it, and educating people
> to disable it if they run into issues, since we'll probably be in the
> same situation in 5 years...and it'll be some time before these
> kernels hit devices/servers anyway.
> 
> Daniel

Unfortunately I think you'll find there are sufficiently large numbers 
of broken SOHO routers out there that if you try this you'll cause a lot 
of problems.  The problems range from no connectivity to in a few 
extreme cases routers actually crashing or behaving in very 
unpredictable ways.  Here's one summary that got presented to the IETF 
about 18 months ago:

http://www.ietf.org/proceedings/07mar/slides/tsvarea-3/sld6.htm

When a clueless end-user gets a Linux-enabled netbook that crashes their 
router while their existing Vista or XP systems appear to work just fine 
then the Linux network stack will get the blame for being buggy, not the 
router :-(


Regards,
Dave


