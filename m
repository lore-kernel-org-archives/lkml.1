Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbZAWTgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbZAWTgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbZAWTga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:36:30 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43428 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbZAWTga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:36:30 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 23 Jan 2009 11:36:28 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
cc: Greg KH <gregkh@suse.de>, Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
In-Reply-To: <195c7a900901230924n13ed225dq4aeff8015d22588e@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901231132590.27255@alien.or.mcafeemobile.com>
References: <20081203193901.715896543@mini.kroah.org>  <20081203194849.GQ8950@kroah.com>  <1232686261.9977.1296303473@webmail.messagingengine.com>  <20090123051620.GA8122@suse.de>  <1232704065.25510.1296328851@webmail.messagingengine.com>  <20090123170631.GB11566@suse.de>
 <195c7a900901230924n13ed225dq4aeff8015d22588e@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Bastien ROUCARIES wrote:

> Why not using a ulimit for this kind of stuff ?

`ulimit` would be great, but it requires userspace code changes for every 
value we want to export. And looking at the amount of configuration we 
have in /proc, it's clear `ulimit` exposure is not very practical.


- Davide


