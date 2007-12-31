Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbXLaRBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbXLaRBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 12:01:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXLaRA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 12:00:58 -0500
Received: from stinky.trash.net ([213.144.137.162]:44739 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXLaRA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 12:00:57 -0500
Message-ID: <47792032.3020609@trash.net>
Date: Mon, 31 Dec 2007 18:00:34 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Harald Welte <laforge@gnumonks.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] ip[6]_tables.c: remove some inlines
References: <200712161247.53986.vda.linux@googlemail.com> <200712270401.35983.vda.linux@googlemail.com> <4775169C.8040302@trash.net> <200712311643.41946.vda.linux@googlemail.com>
In-Reply-To: <200712311643.41946.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> ip[6]_tables.c seem to abuse inline.
>
> This patch removes inlines except those which are used
> by packet matching code and thus are performance-critical.
>   

Some people also consider the ruleset replacement path performance
critical, but overall I agree with your patch. I'm travelling currently
though so it will take a few days until I'll apply it.

Do you have some numbers that show the actual difference these
changes make?


