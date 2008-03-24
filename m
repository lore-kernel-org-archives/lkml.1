Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYCXUW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYCXUW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYCXUWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:22:49 -0400
Received: from khc.piap.pl ([195.187.100.11]:45264 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYCXUWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:22:48 -0400
To: Joe Perches <joe@perches.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wan/wanxl.c: time_before(timeout, jiffies) -> jiffies, timeout
References: <47E28637.4010700@tiscali.nl>
	<1206031566.26345.63.camel@localhost>
	<m3fxug2mk3.fsf@maximus.localdomain>
	<1206373941.4845.21.camel@localhost>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 24 Mar 2008 21:22:46 +0100
In-Reply-To: <1206373941.4845.21.camel@localhost> (Joe Perches's message of "Mon\, 24 Mar 2008 08\:52\:21 -0700")
Message-ID: <m33aqf3m95.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> What's the value of not having schedule() in the
> wanxl_open and wanxl_close routines?

There is no need, it's fast.
-- 
Krzysztof Halasa
