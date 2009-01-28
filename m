Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbZA1Q4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbZA1Q4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZA1Q4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:56:31 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46036 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbZA1Q4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:56:30 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Jan 2009 08:56:29 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Bron Gondwana <brong@fastmail.fm>
cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
In-Reply-To: <1233134693.21525.1297159411@webmail.messagingengine.com>
Message-ID: <alpine.DEB.1.10.0901280854420.20724@alien.or.mcafeemobile.com>
References: <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de><20090128033824.GA1662@brong.net>
 <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com> <20090128035746.GA3351@brong.net> <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com> <20090128052630.GA9512@suse.de><alpine.DEB.1.10.0901272135400.20262@alien.or.mcafeemobile.com>
 <alpine.DEB.1.10.0901272243130.20262@alien.or.mcafeemobile.com> <1233134693.21525.1297159411@webmail.messagingengine.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Bron Gondwana wrote:

> > -       if (unlikely(atomic_read(&user->epoll_devs) >=
> > -                       max_user_instances))
> > +       if (atomic_read(&user->epoll_devs) >= max_user_instances)
> >  		goto free_uid;
> 
> Any reason this has become _less_ unlikely()?

GCC seems to make that choice anyway, according to quite a few tests I ran 
yesterday.


- Davide


