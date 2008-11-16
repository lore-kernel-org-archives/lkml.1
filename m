Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYKPWMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYKPWMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYKPWMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:12:32 -0500
Received: from mail.recluse.de ([78.47.255.98]:42289 "EHLO mail.recluse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbYKPWMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:12:31 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Nov 2008 17:12:31 EST
Message-ID: <4920994B.7010202@bzed.de>
Date: Sun, 16 Nov 2008 23:06:03 +0100
From: Bernd Zeimetz <bernd@bzed.de>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: broken ownership of /proc/sys/ files on 2.6.27
References: <20081116205922.GI28958@anguilla.noreply.org>
In-Reply-To: <20081116205922.GI28958@anguilla.noreply.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Peter Palfrader wrote:
> on several (probably all) of my systems running a 2.6.27 kernel on at
> least i386, amd64, ia64, sparc proc/sys does have files not owned by
> root:


same here:

0 bzed@think:~$ find /proc/sys ! -uid 0
/proc/sys/kernel/shmmni
/proc/sys/kernel/msgmax
/proc/sys/kernel/msgmni
/proc/sys/kernel/msgmnb
/proc/sys/kernel/sem
/proc/sys/fs/quota/allocated_dquots
/proc/sys/fs/quota/free_dquots
/proc/sys/fs/quota/syncs
/proc/sys/fs/quota/warnings
/proc/sys/fs/mqueue/queues_max
/proc/sys/fs/mqueue/msg_max
/proc/sys/fs/mqueue/msgsize_max
/proc/sys/fs/nfs/nlm_grace_period
/proc/sys/fs/nfs/nlm_timeout
/proc/sys/debug
/proc/sys/dev
/proc/sys/dev/raid
/proc/sys/net/ipv4
/proc/sys/net/ipv4/neigh
/proc/sys/net/ipv4/neigh/lo
/proc/sys/net/ipv4/neigh/wlan0
/proc/sys/net/ipv4/neigh/wlan0/retrans_time_ms
/proc/sys/net/ipv6/neigh/lo/retrans_time_ms
/proc/sys/net/ipv6/neigh/lo/base_reachable_time_ms
/proc/sys/net/ipv6/neigh/vbox0
/proc/sys/net/ipv6/neigh/vbox0/retrans_time_ms
/proc/sys/net/ipv6/conf
/proc/sys/net/ipv6/conf/lo/forwarding
/proc/sys/abi
/proc/sys/sunrpc
0 bzed@think:~$ uname -a
Linux think 2.6.27.2-think #1 SMP PREEMPT Thu Oct 23 22:21:17 CEST 2008 x86_64
GNU/Linux
0 bzed@think:~$


> That's probably not how it should be, right?

No...

Cheers,

Bernd

-- 
 Bernd Zeimetz                           Debian GNU/Linux Developer
 GPG Fingerprint: 06C8 C9A2 EAAD E37E 5B2C BE93 067A AD04 C93B FF79
