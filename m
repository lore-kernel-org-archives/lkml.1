Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYDYHNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYDYHNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYDYHNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:13:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47396 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYDYHNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:13:05 -0400
Message-ID: <4811847D.1040209@firstfloor.org>
Date: Fri, 25 Apr 2008 09:13:01 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
References: <480F8936.5030406@hp.com> <87ve27gz4u.fsf@basil.nowhere.org> <67E36C56-E149-4C87-8788-05BA43C1C2AD@kernel.dk> <48109571.70905@hp.com>
In-Reply-To: <48109571.70905@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Another way to attack this would be to have a user level daemon "watch
> things" -

I personally don't like having specialized user mode daemons for things
the kernel can easily do by itself (which is the case here) Linux setups
generally already have too many daemons and they have some overhead,
another one should be only added for very good reasons.

The daemon would be only an excuse here for "we cannot work out a
sensible kernel policy" which would be bad.

-Andi
