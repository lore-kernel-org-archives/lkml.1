Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbYFVJnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbYFVJnF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYFVJmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:42:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:10011 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYFVJmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:42:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MAaO/E0RgPfh3eI5+GFzfXhhMmj/bV75znuWkxyA2Hv4TzMfIn3re51s9iBbICkQY0
         QTWASW8pwUzQNbdrGbKZpg0gLaEg2Z30gJtPQY80W11WExkPv9hzvWWi6LZTP2Q8j+iL
         USFyjbpYxSaNxy2k6VzqFhAU22GF8MWN0YJzA=
Message-ID: <19f34abd0806220242p62b9a044la6dd8843e5055f84@mail.gmail.com>
Date: Sun, 22 Jun 2008 11:42:50 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: v2.6.26-rc7/cgroups: circular locking dependency
Cc: "Paul Menage" <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080622091013.GA7285@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621173859.GA6846@damson.getinternet.no>
	 <20080622091013.GA7285@cvg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 11:10 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Vegard Nossum - Sat, Jun 21, 2008 at 07:38:59PM +0200]
> |  =======================================================
> |  [ INFO: possible circular locking dependency detected ]
> |  2.6.26-rc7 #25
> |  -------------------------------------------------------
> |  bash/10032 is trying to acquire lock:
> |   (&cpu_hotplug.lock){--..}, at: [<c015efbc>] get_online_cpus+0x2c/0x40
> |
> |  but task is already holding lock:
> |   (cgroup_mutex){--..}, at: [<c0160e6f>] cgroup_lock+0xf/0x20

...

> Hi Vegard,
>
> would be interesting to see your config please

Here is my config and vmlinux:

http://www.kernel.org/pub/linux/kernel/people/vegard/kernels/20080621-v2.6.26-rc7/

By the way, I was doing CPU hotplug/unplug at the time.

Thanks :)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
