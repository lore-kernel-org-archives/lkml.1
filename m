Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZA1JZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZA1JZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZA1JYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:24:55 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56542 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbZA1JYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:24:54 -0500
Message-Id: <1233134693.21525.1297159411@webmail.messagingengine.com>
X-Sasl-Enc: 7RMDlRFbDvIQQCTUcrLtN6K5OmxE1FlpzFKGcMhP1yw0 1233134693
From: "Bron Gondwana" <brong@fastmail.fm>
To: "Davide Libenzi" <davidel@xmailserver.org>, "Greg KH" <gregkh@suse.de>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       stable@kernel.org, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <alpine.DEB.1.10.0901272243130.20262@alien.or.mcafeemobile.com>
References: <1232704065.25510.1296328851@webmail.messagingengine.com>
 <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net>
 <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net>
 <20090128003519.GA11395@suse.de><20090128033824.GA1662@brong.net>
 <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com>
 <20090128035746.GA3351@brong.net>
 <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com>
 <20090128052630.GA9512@suse.de><alpine.DEB.1.10.0901272135400.20262@alien.or.mcafeemobile.com>
 <alpine.DEB.1.10.0901272243130.20262@alien.or.mcafeemobile.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Date: Wed, 28 Jan 2009 20:24:53 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Jan 2009 22:57 -0800, "Davide Libenzi" <davidel@xmailserver.org> wrote:
> On Tue, 27 Jan 2009, Davide Libenzi wrote:
> 
> > Or, like Willy said, make (for -stable) the default unlimited, and 
> > let sysadmins to put the bounds if they feel the DoS can apply to them.
> 
> Whose patch follows ...

ACK.

Solves my problem and my "advocate of the poor suffering sysadmins who
have to track down why their stuff suddenly broke with a stable update
hat" problem as well.

One wondering...

> -       if (unlikely(atomic_read(&user->epoll_devs) >=
> -                       max_user_instances))
> +       if (atomic_read(&user->epoll_devs) >= max_user_instances)
>  		goto free_uid;

Any reason this has become _less_ unlikely()?

Thanks,

Bron.


-- 
  Bron Gondwana
  brong@fastmail.fm

