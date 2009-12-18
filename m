Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbZLRRuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbZLRRuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384AbZLRRuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:50:19 -0500
Received: from mail.vyatta.com ([76.74.103.46]:35391 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307AbZLRRuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:50:17 -0500
Date: Fri, 18 Dec 2009 09:49:55 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Michael Stone <michael@laptop.org>
Cc: Mark Seaborn <mrs@mythic-beasts.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?UTF-8?B?QW3DqXJpY28=?= Wang <xiyou.wangcong@gmail.com>,
       Michael Stone <michael@laptop.org>
Subject: Re: [PATCH] Security: Add prctl(PR_{GET,SET}_NETWORK) interface.
Message-ID: <20091218094955.32938765@nehalam>
In-Reply-To: <20091218030056.GC3047@heat>
References: <20091217.225856.145758950057800056.mrs@deli>
	<20091218030056.GC3047@heat>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009 22:00:57 -0500
Michael Stone <michael@laptop.org> wrote:

>    5. Linux today has pretty good support for controlling the creation of
>       channels involving the filesystem and involving shared daemons. It has
>       mediocre support for access control involving sysv-ipc mechanisms. It has
>       terrible support for access control involving non-local principals like
>       "the collection of people and programs receiving packets sent to
>       destination 18.0.0.1:80 from source 192.168.0.3:34661".

The policy control for this is done today on linux via the firewalling infrastructure.
It is not clear to me that moving over to the security infrastructure is an overall
gain from the security or user interface perspective.
