Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbZGOTI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbZGOTI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 15:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbZGOTI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 15:08:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:40295 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbZGOTI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 15:08:58 -0400
Message-ID: <4A5E2944.2070904@suse.cz>
Date: Wed, 15 Jul 2009 21:08:52 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andreas Robinson <andr345@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Scott James Remnant <scott@ubuntu.com>,
       linux-modules@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: generate modules.builtin
References: <20090526152540.GA28341@sepie.suse.cz>	 <20090703144547.GA20980@sepie.suse.cz>	 <1247675954.3968.140.camel@quest>	 <ac3eb2510907150946y461fee0dj6e8f5265b4f91215@mail.gmail.com> <cc43514a0907151104r6208a3dbm89dba496c1411fc0@mail.gmail.com>
In-Reply-To: <cc43514a0907151104r6208a3dbm89dba496c1411fc0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Robinson napsal(a):
> Guys,
> 
> is this patch what you need on the m-i-t end?

I already have patches here (it's not against Jon's master, but it
should apply):
http://repo.or.cz/w/mit.git?a=commit;h=45c29de1b54478a63352a3f13c570a964903f54f
http://repo.or.cz/w/mit.git?a=commit;h=0e72912a1e0b486225f7052c8d40e28b07ff4495

The idea is that modprobe should just do nothing and exit successfully,
so that scripts don't break nor start printing warnings if the kernel
config changes. I meant to send it to linux-modules once there is
agreement about the modules.builtin file format.

Michal
