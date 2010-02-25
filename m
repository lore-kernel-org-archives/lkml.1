Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab0BYQvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:51:48 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:34852 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932967Ab0BYQvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:51:43 -0500
Date: Thu, 25 Feb 2010 19:51:41 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Sandeep Gopalpet <Sandeep.Kumar@freescale.com>, davem@davemloft.net,
       Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Gianfar driver failing on MPC8641D based board
Message-ID: <20100225165141.GA9686@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <4B6C2488.3060403@ge.com>
 <4B865176.7080806@ge.com>
 <4B86A97E.6050509@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B86A97E.6050509@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 04:46:54PM +0000, Martyn Welch wrote:
[...]
> > nfs: server 192.168.0.1 not responding, still trying
> >   
> 
> Further testing has shown that this isn't restricted to warm reboots, it
> happens from cold as well. In addition, the exact timing of the failure
> seems to vary, some boots have got further before failing.

Unfortunately I don't have any 8641 boards near me, so I can't
debug this myself. Though, I tested gianfar on MPC8568E-MDS with
2.6.33 kernel, and it seems to work just fine.

I see you use SMP. Can you try to turn it off? If that will fix
the issue, then it'll be a good data point.

Meanwhile, I'll try SMP kernel on MPC8568 (UP), and let you
know the results.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
