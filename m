Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYGRVCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYGRVCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYGRVCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:02:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41211 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbYGRVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:02:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <488104C9.6080108@s5r6.in-berlin.de>
Date: Fri, 18 Jul 2008 23:02:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Surprising Code In sound/core/pcm_native.c In Recent Git Tree
References: <416584.18514.qm@web59516.mail.ac4.yahoo.com>
In-Reply-To: <416584.18514.qm@web59516.mail.ac4.yahoo.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soumyadip Das Mahapatra wrote:
> When i was reading the code in sound/core/pcm_native.c in
> recent git tree, i got stuck in  line no 3258. It is something
> like this
> snd_assert(substream != NULL, goto out);
> 
> That (goto statement) surprised me for a while unless i came to
> know snd_assert() is a macro (as expected!). Previous version
> too had a return statement in it.
> 
> The point is that can we have a nicer code? Because this type
> of code is sometimes __CONFUSING__.

Curious.  The "goto out", "return -EIO" and friends are not compiled in 
if CONFIG_SND_DEBUG is not set.

Why would anybody want a debug macro to exit from functions?

BTW, grep tells me there are 829 occurrences of snd_assert in linux 2.6.26.
-- 
Stefan Richter
-=====-==--- -=== =--=-
http://arcgraph.de/sr/
