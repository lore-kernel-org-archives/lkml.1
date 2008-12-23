Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbYLWQbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbYLWQbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYLWQbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:31:19 -0500
Received: from khc.piap.pl ([195.187.100.11]:56375 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYLWQbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:31:18 -0500
To: =?utf-8?B?SMOla29uIEzDuHZkYWw=?= <hlovdal@gmail.com>
Cc: "Hannes Eder" <hannes@hanneseder.net>, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/27] drivers/net: fix sparse warnings: make do-while a compound statement
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191507.11807.50794.stgit@vmbox.hanneseder.net>
	<m3hc4voo2a.fsf@maximus.localdomain>
	<a01a16b50812221544x45c3559ap808ac0095ee8f01@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 23 Dec 2008 17:31:15 +0100
In-Reply-To: <a01a16b50812221544x45c3559ap808ac0095ee8f01@mail.gmail.com>
 (=?utf-8?Q?=22H=C3=A5kon_L=C3=B8vdal=22's?= message of "Tue\, 23 Dec 2008
 00\:44\:25 +0100")
Message-ID: <m3ocz2ua3w.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Håkon Løvdal" <hlovdal@gmail.com> writes:

> For this specific issue the important aspect is to improve readability
> (and not just eventually satisfy some warning from a tool), which I
> assume there is no disagrement on.

Precisely.

> Now what constitutes improved
> readbility on the other hand is another issue, and I guess there are
> next to as many oppinions as developers... :)

Yes. Thus the brackets (or lack of them) of do-while loops should
never be forced as a part of coding standard/tools. This is just an
unimportant detail of personal style and trying to force it is simply
damaging to all of us.

> Of secondary importance is the benefit that always using brackets
> makes them much more merge friendly.

There are many ways to make the code more merge friendly at a cost of
readability. Hope we don't go this way.
-- 
Krzysztof Halasa
