Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYHLDsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYHLDsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYHLDsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:48:05 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59613 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751189AbYHLDsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:48:04 -0400
Date: Mon, 11 Aug 2008 22:48:00 -0500
From: Paul Jackson <pj@sgi.com>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: menage@google.com, linux-kernel@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Removes extra checking kernel/cpuset.c
Message-Id: <20080811224800.ab8e5c79.pj@sgi.com>
In-Reply-To: <b9df5fa10808020907g774a88ddj8111a5ffcbe62eb5@mail.gmail.com>
References: <b9df5fa10808020907g774a88ddj8111a5ffcbe62eb5@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This PATCH has the exact same name 'Removes extra checking kernel/cpuset.c'
as another, different PATCH:
  1) sent 7/31: kernel/cpuset.c guarantee_online_mems() and guarantee_online_cpus()
  2) this one, sent 8/2: kernel/cpuset.c update_domain_attr().

Please use different names for different patches.

And this one, for update_domain_attr(), probably conflicts with other
work being done by Max K (I'll add him to the CC list, above) which relies
on this dattr check here, as commented in a recent patch of his:

  cpuset: Rework sched domains and CPU hotplug handling (take 4)

-OR- it conflicts with the code version that Li Zefan was referring
to in his comment:

> The above code no longer exists in latest-git.

I'm not sure which conflict is still relevant here.

How about you wait for the dust to settle on Max K's above patch,
and then consider if this change is still useful?  I suspect it
won't be useful.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
