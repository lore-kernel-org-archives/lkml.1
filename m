Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXC3QRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXC3QRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXC3QRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:17:09 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:58332 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbXC3QRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:17:07 -0400
Date: Fri, 30 Mar 2007 18:16:16 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Ken Chen <kenchen@google.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] remove artificial software max_loop limit
In-Reply-To: <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0703301813120.31834@yvahk01.tjqt.qr>
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com> 
 <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com> 
 <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
 <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 30 2007 02:25, Ken Chen wrote:
>
> Oh, crap.  Google mail is innocent.  It was me who did some ugly
> copy-paste between apps.

Well, you did it again :p

> I don't mind either way, this thing won't be bigger than 1^20 anyway.
> Oh, which reminds me that we probably should explicitly test and cap
> that limit (1^20 that is).

I do not think is needed, since it will already be caught by the
layout of a dev_t.

> +static struct loop_device *loop_find_dev(int number)
> +{
> +	struct loop_device *lo;
> +
> +	list_for_each_entry(lo, &loop_devices, lo_list) {
> +		if (lo->lo_number == number)
> +			return lo;
> +	}

Can do without {}


Jan
-- 
