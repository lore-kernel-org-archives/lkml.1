Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbYCXPxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbYCXPxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYCXPw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:52:56 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4080 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbYCXPw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:52:56 -0400
Subject: Re: [PATCH] drivers/net/wan/wanxl.c: time_before(timeout, jiffies)
	-> jiffies, timeout
From: Joe Perches <joe@perches.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <m3fxug2mk3.fsf@maximus.localdomain>
References: <47E28637.4010700@tiscali.nl>
	 <1206031566.26345.63.camel@localhost>  <m3fxug2mk3.fsf@maximus.localdomain>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 08:52:21 -0700
Message-Id: <1206373941.4845.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-24 at 16:01 +0100, Krzysztof Halasa wrote:
> Joe Perches <joe@perches.com> writes:
> > Wouldn't it be better to have a schedule() in those
> > while loops too?
> There is a schedule() here:

What's the value of not having schedule() in the
wanxl_open and wanxl_close routines?


